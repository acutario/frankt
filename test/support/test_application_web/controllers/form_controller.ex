defmodule Frankt.TestApplicationWeb.FormController do
  use Frankt.TestApplicationWeb, :controller

  alias Frankt.TestApplication.People.User

  def index(conn, _params) do
    render(conn, "index.html", changeset: User.changeset(%User{}))
  end

  def create(conn, _params) do
    conn
    |> put_flash(:info, "Thank you for trying Frankt!")
    |> redirect(to: form_path(conn, :index))
  end
end
