defmodule Frankt.TestApplicationWeb.FranktHandlers.Chat do
  alias Frankt.TestApplicationWeb.Endpoint

  def chat(%{"sender" => sender, "message" => msg}, socket) do
    Endpoint.broadcast("frankt:chat", "new_msg", %{
      sender: sender,
      message: msg
    })

    socket
  end

  def chat(_params, socket), do: socket
end
