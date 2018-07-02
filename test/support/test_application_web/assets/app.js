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

  // Chat demo
  const chat = document.querySelector("div.chat");

  if (chat) {
    chat.insertAdjacentHTML('beforeend', '<p><i>Connecting...</i></p>');
    var frankt_chat = Frankt.connect("chat:lobby", socket_params)
      .receive("ok", (res) => {
        chat.insertAdjacentHTML('beforeend', '<p><i>Connected!</i></p>');
      });
    frankt_chat.channel.on("new_msg", (res) => {
      chat.insertAdjacentHTML('beforeend', `<p><b>${res.sender}:</b> ${res.message}</p>`);
    });
  }
}
