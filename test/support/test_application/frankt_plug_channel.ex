defmodule Frankt.TestApplication.FranktPlugChannel do
  @moduledoc false

  use Phoenix.Channel

  use Frankt

  def join("frankt:" <> _identifier, _payload, socket), do: {:ok, socket}

  def handlers do
    %{"frankt_actions" => Frankt.TestApplication.FranktActions}
  end

  def plugs do
    [
      Frankt.TestApplication.Plug
    ]
  end
end
