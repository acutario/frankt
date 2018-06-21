defmodule Frankt.TestApplication.PageController do
  use Frankt.TestApplication, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
