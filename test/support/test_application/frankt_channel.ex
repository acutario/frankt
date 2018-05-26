defmodule Frankt.TestApplication.FranktChannel do
  use Phoenix.Channel

  use Frankt

  def join("frankt:" <> _identifier, _payload, socket), do: {:ok, socket}
end
