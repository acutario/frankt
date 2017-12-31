import $ from 'jquery';
import * as Dom from './dom';
import {Socket} from 'phoenix';
import serialize from 'form-serialize';

export let channel = {};

export function serializeForm(element) {
  const data = [];
  data.push({csrf_token: $('meta[name=csrf]').attr('content')});

  if (element.name) {
    data.push(Dom.serializeElement(element.name));
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

    data.push(serialize(target, {hash: true}));
  }

  return Object.assign(...data);
}

export function sendMsg(action, data) {
  if (channel.state === 'closed') init(true);
  return channel.push(action, data);
}

function handleEvent(e) {
  const target = e.currentTarget;
  const data = serializeForm(target);
  e.preventDefault();
  if (data) sendMsg(target.dataset.franktAction, data);
  return false;
}

function handleAutoEvent(e) {
  const target = e.currentTarget;
  const value = target.value;

  if (value.length === 0 || value.length >= 2) handleEvent(e);
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
  $(document).on("submit change click", "[data-frankt-action]:not(input)", handleEvent);
  $(document).on("change", "input[data-frankt-action]", handleEvent);
  $(document).on("keyup", "input[data-frankt-auto]", handleAutoEvent);
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
