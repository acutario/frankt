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
  const chat = document.querySelector("div.chat textarea");

  if (chat) {
    var frankt_chat = Frankt.connect("frankt:chat", socket_params)
    frankt_chat.channel.on("new_msg", (res) => { alert("Message from " + res.sender + " : " + res.message); });
  }
}
