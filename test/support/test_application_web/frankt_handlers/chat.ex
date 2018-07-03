defmodule Frankt.TestApplicationWeb.FranktHandlers.Chat do
  import Frankt.Handler

  alias Frankt.TestApplicationWeb.Endpoint
  alias Frankt.TestApplicationWeb.ChatView

  def send(%{"chat" => %{"sender" => sender, "message" => msg}}, socket) do
    Endpoint.broadcast(socket.topic, "append", %{
      html: render(socket, ChatView, "_message.html", sender: sender, message: msg),
      target: "#chat"
    })
  end
end
