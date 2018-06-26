defmodule Frankt.TestApplication.FilterController do
  use Frankt.TestApplication, :controller

  @users [
    %{name: "Bret Slater", gender: "male", birth: "1947-06-02"},
    %{name: "Annamarie Herrera", gender: "female", birth: "	1968-10-02"},
    %{name: "Isabel Fry", gender: "female", birth: "1964-05-22"},
    %{name: "Jamila Cohen", gender: "female", birth: "1973-09-28"},
    %{name: "Blair Roy", gender: "male", birth: "1986-09-14"}
  ]

  def index(conn, _params) do
    render(conn, "index.html", users: @users)
  end

  def users, do: @users
end
