defmodule Frankt.TestApplicationWeb.FranktHandlers.Form do
  import Phoenix.Channel
  import Frankt.Handler

  alias Frankt.TestApplication.People.User
  alias Frankt.TestApplicationWeb.FormView, as: View

  def update(%{"user" => params}, socket) do
    changeset = User.changeset(%User{}, params)

    push(socket, "replace_with", %{
      html: render(socket, View, "index.html", changeset: changeset, conn: %Plug.Conn{}),
      target: "#user-form"
    })
  end
end
