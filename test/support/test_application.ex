defmodule Frankt.TestApplication do
  use Application

  alias Frankt.TestApplication.Endpoint

  def start(_type, _args) do
    children = [{Endpoint, []}]
    Supervisor.start_link(children, strategy: :one_for_one, name: __MODULE__)
  end
end
