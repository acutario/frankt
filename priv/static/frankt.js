import $ from 'jquery';
import * as Dom from './dom';
import {Socket} from 'phoenix';

export let channel = {};

export function sendMsg(action, data) {
  if (channel.state === 'closed') init(true);
  return channel.push(action, data);
}

export function serializeForm(element) {
  const data = [];
  data.push({csrf_token: document.querySelector('meta[name=csrf]').content});

  if (element.name) {
    data.push(Dom.serializeElement(element));
  }

  if (element.dataset.franktTarget) {
    const target = document.querySelector(element.dataset.franktTarget);

    // Block submit form on enter
    $(target).on('submit', (e) => {
      e.preventDefault();
    });

    if (Dom.needValidation(element, target)) {
      return target.reportValidity();
    }

    data.push(Dom.serialize(target, {hash: true}));
  }

  return Object.assign(...data);
}

function handleEvent(e, selector) {
  if (!e.target.matches(selector)) return true;
  e.preventDefault();
  const target = e.target;
  const data = serializeForm(target);
  if (data) sendMsg(target.dataset.franktAction, data);
}

function attachResponses() {
  channel.on("redirect", (res) => window.location = res.target);
  channel.on("replace_with", (res) => $(res.target).replaceWith(res.html));
  channel.on("prepend", (res) => $(res.target).prepend(res.html));
  channel.on("append", (res) => $(res.target).append(res.html));
  channel.on("mod_class", (res) => {
    for (const element of document.querySelectorAll(res.target)) {
      element.classList[res.action](res.klass);
    }
  });
}

function attachEvents() {
  document.addEventListener('click', (e) => handleEvent(e, '[data-frankt-action]:not(input)'), true);
  document.addEventListener('change', (e) => handleEvent(e, '[data-frankt-action]'), true);
  document.addEventListener('submit', (e) => handleEvent(e, '[data-frankt-action]'), true);
  document.addEventListener('keyup', (e) => handleEvent(e, '[data-frankt-auto]'), true);
}

// Connect to the socket and join the Frankt channel.
export function connect(channel_name, socket_params) {
  const socket = new Socket('/socket', { params: socket_params });
  socket.connect();
  channel = socket.channel(channel_name, {});
  return channel.join()
    .receive("ok", res => {
      attachEvents()
      attachResponses();
      console.log("Connected to Frankt");
    })
    .receive("error", res => console.log("Unable to connect to Frankt", res));
};
