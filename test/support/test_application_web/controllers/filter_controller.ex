defmodule Frankt.TestApplicationWeb.FilterController do
  use Frankt.TestApplicationWeb, :controller

  alias Frankt.TestApplication.People

  def index(conn, _params) do
    render(conn, "index.html", users: People.filter_users())
  end
end
