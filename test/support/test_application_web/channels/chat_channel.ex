defmodule Frankt.TestApplicationWeb.ChatChannel do
  use Frankt.TestApplicationWeb, :channel
  use Frankt

  def join("chat:lobby", _params, socket) do
    send(self(), :welcome_message)

    {:ok, socket}
  end

  def handle_info(:welcome_message, socket) do
    push(socket, "new_msg", %{
      sender: gettext("Frankt"),
      message:
        gettext(
          "Welcome to Frankt example chat! As soon as someone connected write something it will appear here."
        )
    })

    {:noreply, socket}
  end

  def handlers do
    %{
      "chat" => Frankt.TestApplicationWeb.FranktHandlers.Chat
    }
  end
end
