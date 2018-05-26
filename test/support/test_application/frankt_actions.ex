defmodule Frankt.TestApplication.FranktActions do
  import Phoenix.Channel

  def redirect(_params, socket) do
    push(socket, "redirect", %{target: "/"})
  end
end
