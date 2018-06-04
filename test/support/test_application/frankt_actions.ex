defmodule Frankt.TestApplication.FranktActions do
  @moduledoc false

  import Phoenix.Channel

  def redirect(_params, socket) do
    # Simulate some business logic and then provide a message, for example a redirection.
    push(socket, "redirect", %{target: "/"})
  end

  def break(_params, _socket) do
    # Simulate an uncontrolled error that may happen in user code.
    raise RuntimeError
  end
end
