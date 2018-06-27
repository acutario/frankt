defmodule Frankt.TestApplicationWeb.FranktHandlers.Filter do
  import Phoenix.Channel
  import Frankt.Handler

  alias Frankt.TestApplicationWeb.FilterView, as: View

  def filter(%{"filters" => filters}, socket) do
    push(socket, "replace_with", %{
      html: render(socket, View, "_table.html", users: filter_users(filters)),
      target: "#users"
    })
  end

  # TODO this would be better refactored to its own module
  defp filter_users(filters) do
    Frankt.TestApplicationWeb.FilterController.users()
    |> filter_by_name(filters)
    |> filter_by_gender(filters)
  end

  defp filter_by_name(users, %{"name" => name}) when name != "" do
    Enum.filter(users, &String.contains?(&1.name, name))
  end

  defp filter_by_name(users, _), do: users

  defp filter_by_gender(users, %{"gender" => gender}) when gender != "" do
    Enum.filter(users, &Kernel.==(&1.gender, gender))
  end

  defp filter_by_gender(users, _), do: users
end
