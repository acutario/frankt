defmodule Frankt.TestApplicationWeb.FranktHandlers.Form do
  import Phoenix.Channel
  import Frankt.Handler

  alias Frankt.TestApplication.People.User
  alias Frankt.TestApplicationWeb.FormView, as: View

  def update(%{"user" => params}, socket) do
    form =
      %User{}
      |> User.changeset(params)
      |> Phoenix.HTML.FormData.to_form([])

    push(socket, "replace_with", %{
      html: render(socket, View, "_email.html", form: form),
      target: "#user-form-email"
    })
  end
end
