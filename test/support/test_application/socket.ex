defmodule Frankt.TestApplication.Socket do
  @moduledoc false

  use Phoenix.Socket

  channel("room:*", Frankt.TestApplication.FranktChannel)

  transport(:websocket, Phoenix.Transports.WebSocket)

  def connect(_params, socket), do: {:ok, socket}

  def id(_socket), do: nil
end
