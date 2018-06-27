defmodule Frankt.TestApplicationWeb.FranktHandlers.Filter do
  import Phoenix.Channel
  import Frankt.Handler

  alias Frankt.TestApplication.People
  alias Frankt.TestApplicationWeb.FilterView, as: View

  def filter(params, socket) do
    users =
      params
      |> Map.get("filters", %{})
      |> People.filter_users()

    push(socket, "replace_with", %{
      html: render(socket, View, "_table.html", users: users),
      target: "#users"
    })
  end
end
