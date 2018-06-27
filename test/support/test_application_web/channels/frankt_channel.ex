defmodule Frankt.TestApplicationWeb.FranktChannel do
  use Frankt.TestApplicationWeb, :channel
  use Frankt

  def join("frankt:" <> _user_id, _params, socket), do: {:ok, socket}

  def handlers do
    %{
      "greeting" => Frankt.TestApplicationWeb.FranktHandlers.Greeting,
      "filter" => Frankt.TestApplicationWeb.FranktHandlers.Filter
    }
  end
end
