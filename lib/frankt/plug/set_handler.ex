defmodule Frankt.Plug.SetHandler do
  @moduledoc """
  Sets the Frankt handler information for the incoming action.

  The handler is stored under the `frankt_handler` key in the form of a
  `{handler_module, handler_fn}` tuple.
  """
  @behaviour Frankt.Plug

  alias Frankt.ConfigurationError

  def call(socket = %{private: %{frankt_action: action} = private}, _opts) do
    [handler_name, handler_fn] = String.split(action, ":")
    handler = {handler(socket, handler_name), String.to_existing_atom(handler_fn)}

    %{socket | private: Map.put(private, :frankt_handler, handler)}
  end

  defp handler(%{private: %{frankt_module: frankt_module}}, handler_name)
       when is_binary(handler_name) do
    case Map.get(frankt_module.handlers(), handler_name) do
      nil -> no_handler_found(frankt_module, handler_name)
      handler_module -> handler_module
    end
  end

  defp no_handler_found(module, handler_name) do
    raise ConfigurationError,
      module: module,
      message:
        "Frankt can not find a handler for '#{handler_name}'. Please, chech that you are using the correct name or define a new handler in your configuration."
  end
end
