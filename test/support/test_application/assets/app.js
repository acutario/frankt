import * as Frankt from 'frankt';

window.onload = function () {
  const channel_tag = document.querySelector("meta[name=channel]");

  const socket_params = {
    locale: document.querySelector('html').getAttribute('lang')
  };

  Frankt.connect(channel_tag.content, socket_params)
    .receive("ok", (res) => {
      console.log('do your magic!', res);
    });
}
