defmodule Frankt.TestApplication.FranktHandlers.Greeting do
  import Phoenix.Channel
  import Frankt.Handler

  alias Frankt.TestApplication.PageView, as: View

  def greet(%{"greet" => %{"name" => name}}, socket) do
    push(socket, "replace_with", %{
      html: render(socket, View, "_greeting.html", name: name),
      target: "#greeting"
    })
  end
end
