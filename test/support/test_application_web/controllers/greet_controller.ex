defmodule Frankt.TestApplicationWeb.GreetController do
  use Frankt.TestApplicationWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
