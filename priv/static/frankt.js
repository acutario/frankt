import $ from 'jquery';
import {Socket}  from "phoenix";
import serialize from "form-serialize";
// import * as Modal from "services/modal";

const channelName = document.querySelector("meta[name=channel]").getAttribute("content");
const userToken = document.querySelector("meta[name=user_token]").getAttribute("content");
const tenantToken = document.querySelector("meta[name=tenant_token]").getAttribute("content");
const locale = document.querySelector('html').getAttribute('lang');
const socket = new Socket("/socket", { params: {user_token: userToken, tenant_token: tenantToken, locale: locale} });
const frankenstein = socket.channel(channelName, {});
const form_tpl = $('<form><input type="hidden"/></form>');

function needValidation(element, target) {
  if (element.dataset.frankensteinNoValidate !== undefined) return false;
  return target.nodeName === "FORM" && !target.checkValidity();
}

function generateFakeInput(name, value) {
  let fake_el = form_tpl.clone();
  fake_el.find('input').attr('name', name).val(value);
  return serialize(fake_el[0], {hash: true});
}

export function getTargetData(element) {
  const data = [];

  data.push(generateFakeInput('csrf_token', $('meta[name=csrf]').attr('content')));

  if (element.name) {
    data.push(generateFakeInput(element.name, element.value));
  }

  if (element.dataset.frankensteinTarget) {
    const target = document.querySelector(element.dataset.frankensteinTarget);

    // Block submit form on enter
    $(target).on('submit', (e) => {
      e.preventDefault();
    });

    if (needValidation(element, target)) {
      return target.reportValidity();
    }

    data.push(serialize(target, {hash: true}));
  }

  return merge(...data);
}

export function sendMsg(action, data) {
  if (frankenstein.state === 'closed') init(true);
  return frankenstein.push(action, data);
}

function handleEvent(e) {
  const target = e.currentTarget;
  const data = getTargetData(target);
  e.preventDefault();
  if (data) sendMsg(target.dataset.frankensteinAction, data);
  return false;
}

function handleAutoEvent(e) {
  const target = e.currentTarget;
  const value = target.value;

  if (value.length === 0 || value.length >= 2) handleEvent(e);
}

function attachResponses(frankenstein) {
  frankenstein.on("redirect", (res) => window.location = res.target);
  frankenstein.on("replace_with", (res) => {
    $(res.target).replaceWith(res.html);
    $(res.target).trigger('dom-update');
  });
  frankenstein.on("mod_class", (res) => {
    for (const element of document.querySelectorAll(res.target)) {
      element.classList[res.action](res.klass);
    }
  });
  frankenstein.on("open_modal", (res) => Modal.open(res.html));
  frankenstein.on("close_modal", (res) => Modal.close());
  frankenstein.on("prepend", (res) => {
    $(res.target).prepend(res.html);
    $(res.target).trigger('dom-update');
  });
  frankenstein.on("append", (res) => {
    $(res.target).append(res.html);
    $(res.target).trigger('dom-update');
  });
  frankenstein.on("notification_watcher", () => {
    sendMsg("notification_watcher");
  });
}

// Connect to the socket and join the Frankenstein channel (only if there are
// Frankenstein elements in the DOM).
export function init(force = false) {
  $(document).on("submit change click", "[data-frankenstein-action]:not(input)", handleEvent);
  $(document).on("change", "input[data-frankenstein-action]", handleEvent);
  $(document).on("keyup", "input[data-frankenstein-auto]", handleAutoEvent);

  socket.connect();
  return frankenstein.join()
    .receive("ok", res => {
      attachResponses(frankenstein);
      console.log("Connected to Frankenstein");
    })
    .receive("error", res => console.log("Unable to connect to Frankenstein", res));

  sendMsg("notification_watcher");
}

// export default $(() => init());
