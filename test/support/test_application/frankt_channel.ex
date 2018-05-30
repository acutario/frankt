defmodule Frankt.TestApplication.FranktChannel do
  @moduledoc false

  use Phoenix.Channel

  use Frankt

  def join("frankt:" <> _identifier, _payload, socket), do: {:ok, socket}

  def handlers do
    %{"frankt_actions" => Frankt.TestApplication.FranktActions}
  end
end
