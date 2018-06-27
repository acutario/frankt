defmodule Frankt.TestApplicationWeb.FranktHandlers.Filter do
  import Phoenix.Channel
  import Frankt.Handler

  alias Frankt.TestApplication.People
  alias Frankt.TestApplicationWeb.FilterView, as: View

  def filter(%{"filters" => filters}, socket) do
    push(socket, "replace_with", %{
      html: render(socket, View, "_table.html", users: People.filter_users(filters)),
      target: "#users"
    })
  end
end
