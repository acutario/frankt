import * as Dom from './dom';
import {
  Socket
} from 'phoenix';

export let channel = {};

export let socket = {};

export function sendMsg(action, data, topic = channel.topic) {
  const channel = socket.channels.filter(c => c.topic === topic)[0] || channel;
  return channel.push('frankt-action', {
    action: action,
    data: data
  });
}

export function serializeForm(element) {
  const data = [{}];

  if (element.name && element.tagName !== "INPUT") {
    data.push(Dom.serializeElement(element));
  }

  if (element.dataset.franktData) {
    data.push(JSON.parse(element.dataset.franktData));
  }

  if (element.dataset.franktTarget) {
    const target = document.querySelector(element.dataset.franktTarget);
    // Block submit form on enter
    target.addEventListener('keydown', Dom.blockSubmit, true);

    if (Dom.needValidation(element, target)) {
      return target.reportValidity();
    }

    data.push(Dom.serialize(target, {
      hash: true
    }));
  }

  return Object.assign(...data);
}

function handleEvent(e, selector) {
  if (e.target.matches(selector) || e.target.closest(selector)) {
    const target = e.target.matches(selector) ? e.target : e.target.closest(selector);
    const topic = e.target.dataset.franktTopic ? e.target.dataset.franktTopic : channel.topic
    e.preventDefault();
    const data = serializeForm(target);
    if (data) sendMsg(target.dataset.franktAction, data, topic);
    return false;
  }
}

function attachResponses() {
  channel.on("redirect", (res) => window.location = res.target);
  channel.on("replace_with", (res) => document.querySelector(res.target).outerHTML = res.html);
  channel.on("append", (res) => document.querySelector(res.target).insertAdjacentHTML('beforeend', res.html));
  channel.on("prepend", (res) => document.querySelector(res.target).insertAdjacentHTML('afterbegin', res.html));
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
  socket = new Socket('/socket', {
    params: socket_params
  });
  socket.connect();
  channel = socket.channel(channel_name, {});
  return channel.join()
    .receive("ok", res => {
      attachEvents();
      attachResponses();
      console.log("Connected to Frankt");
    })
    .receive("error", res => console.log("Unable to connect to Frankt", res));
};

export function join(channel_name) {
  let channel = socket.channel(channel_name, {});
  return channel.join();
}
