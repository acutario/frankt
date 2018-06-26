defmodule Frankt.TestApplication.FranktChannel do
  use Frankt.TestApplication, :channel
  use Frankt

  def join("frankt:" <> _user_id, _params, socket), do: {:ok, socket}

  def handlers do
    %{
      "greeting" => Frankt.TestApplication.FranktHandlers.Greeting,
      "filter" => Frankt.TestApplication.FranktHandlers.Filter
    }
  end
end
