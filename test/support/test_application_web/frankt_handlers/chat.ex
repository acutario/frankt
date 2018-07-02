defmodule Frankt.TestApplicationWeb.FranktHandlers.Chat do
  alias Frankt.TestApplicationWeb.Endpoint

  def send(%{"chat" => %{"sender" => sender, "message" => msg}}, socket) do
    Endpoint.broadcast("chat:lobby", "message", %{
      sender: sender,
      message: msg
    })

    socket
  end

  def chat(_params, socket), do: socket
end
