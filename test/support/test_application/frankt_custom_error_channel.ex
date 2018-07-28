defmodule Frankt.TestApplication.FranktCustomErrorChannel do
  @moduledoc false

  use Phoenix.Channel

  use Frankt

  def join("frankt:" <> _identifier, _payload, socket), do: {:ok, socket}

  def handlers do
    %{"frankt_actions" => Frankt.TestApplication.FranktActions}
  end

  def handle_error(_error, stacktrace, socket, _params) do
    push(socket, "custom-error-handled", %{})
    {:noreply, socket}
  end
end
