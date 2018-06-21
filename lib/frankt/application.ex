defmodule Frankt.Application do
  use Application

  def start(_type, _args) do
    children =
      if Code.ensure_compiled?(Frankt.TestApplication),
        do: [{Frankt.TestApplication.Endpoint, []}],
        else: []

    Supervisor.start_link(children, strategy: :one_for_one, name: Frankt.Supervisor)
  end

  def config_change(changed, _new, removed) do
    if Code.ensure_compiled?(Frankt.TestApplication) do
      Frankt.TestApplication.Endpoint.config_change(changed, removed)
    end

    :ok
  end
end
