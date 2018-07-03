defmodule Frankt.TestApplicationWeb.ChatChannel do
  use Frankt.TestApplicationWeb, :channel
  use Frankt

  import Frankt.Handler
  alias Frankt.TestApplicationWeb.ChatView

  def join("chat:lobby", _params, socket) do
    send(self(), :welcome_message)

    {:ok, socket}
  end

  def handle_info(:welcome_message, socket) do
    push(socket, "append", %{
      html: render(socket, ChatView, "_message.html", sender: "SYSTEM", message: "Connected!"),
      target: "#chat"
    })

    push(socket, "append", %{
      html:
        render(
          socket,
          ChatView,
          "_message.html",
          sender: "SYSTEM",
          message:
            gettext(
              "Welcome to Frankt example chat! As soon as someone connected write something it will appear here."
            )
        ),
      target: "#chat"
    })

    {:noreply, socket}
  end

  def handlers do
    %{
      "chat" => Frankt.TestApplicationWeb.FranktHandlers.Chat
    }
  end
end
