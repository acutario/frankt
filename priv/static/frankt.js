import {Socket}  from "phoenix";
import serialize from "form-serialize";
// import * as Modal from "services/modal";

const channelName = document.querySelector("meta[name=channel]").getAttribute("content");
const userToken = document.querySelector("meta[name=user_token]").getAttribute("content");
const tenantToken = document.querySelector("meta[name=tenant_token]").getAttribute("content");
const locale = document.querySelector('html').getAttribute('lang');
const socket = new Socket("/socket", { params: {user_token: userToken, tenant_token: tenantToken, locale: locale} });
const frankt = socket.channel(channelName, {});
const form_tpl = $('<form><input type="hidden"/></form>');

function needValidation(element, target) {
  if (element.dataset.franktNoValidate !== undefined) return false;
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

  if (element.dataset.franktTarget) {
    const target = document.querySelector(element.dataset.franktTarget);

    // Block submit form on enter
    $(target).on('submit', (e) => {
      e.preventDefault();
    });

    if (needValidation(element, target)) {
      return target.reportValidity();
    }

    data.push(serialize(target, {hash: true}));
  }

  return Object.assign(...data);
}

export function sendMsg(action, data) {
  if (frankt.state === 'closed') init(true);
  return frankt.push(action, data);
}

function handleEvent(e) {
  const target = e.currentTarget;
  const data = getTargetData(target);
  e.preventDefault();
  if (data) sendMsg(target.dataset.franktAction, data);
  return false;
}

function handleAutoEvent(e) {
  const target = e.currentTarget;
  const value = target.value;

  if (value.length === 0 || value.length >= 2) handleEvent(e);
}

function attachResponses(frankt) {
  frankt.on("redirect", (res) => window.location = res.target);
  frankt.on("replace_with", (res) => {
    $(res.target).replaceWith(res.html);
    $(res.target).trigger('dom-update');
  });
  frankt.on("mod_class", (res) => {
    for (const element of document.querySelectorAll(res.target)) {
      element.classList[res.action](res.klass);
    }
  });
  // frankt.on("open_modal", (res) => Modal.open(res.html));
  // frankt.on("close_modal", (res) => Modal.close());
  frankt.on("prepend", (res) => {
    $(res.target).prepend(res.html);
    $(res.target).trigger('dom-update');
  });
  frankt.on("append", (res) => {
    $(res.target).append(res.html);
    $(res.target).trigger('dom-update');
  });
  frankt.on("notification_watcher", () => {
    sendMsg("notification_watcher");
  });
}

// Connect to the socket and join the Frankt channel (only if there are
// Frankt elements in the DOM).
export function init(force = false) {
  $(document).on("submit change click", "[data-frankt-action]:not(input)", handleEvent);
  $(document).on("change", "input[data-frankt-action]", handleEvent);
  $(document).on("keyup", "input[data-frankt-auto]", handleAutoEvent);

  socket.connect();
  return frankt.join()
    .receive("ok", res => {
      attachResponses(frankt);
      sendMsg("notification_watcher");
      console.log("Connected to Frankt");
    })
    .receive("error", res => console.log("Unable to connect to Frankt", res));
}

// export default $(() => init());
