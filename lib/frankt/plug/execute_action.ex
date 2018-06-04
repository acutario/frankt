defmodule Frankt.Plug.ExecuteAction do
  @moduledoc """
  Runs the user handler for the incoming Frankt action.
  """
  @behaviour Frankt.Plug

  alias Frankt.ConfigurationError

  def call(socket = %{private: %{frankt_gettext: nil}}, _opts) do
    invoke_action(socket)
  end

  def call(socket = %{private: %{frankt_gettext: gettext}, assigns: %{locale: locale}}, _opts)
      when is_binary(locale) or is_atom(locale) do
    Gettext.with_locale(gettext, locale, fn ->
      invoke_action(socket)
    end)
  end

  def call(%{private: %{frankt_module: frankt_module}}, _opts) do
    raise ConfigurationError,
      module: frankt_module,
      message:
        "You have configured Frankt to use Gettext for i18n, but the response does not know which locale to use. Please store the desired locale into a `locale` assign in the socket."
  end

  defp invoke_action(
         socket = %{
           private: %{
             frankt_module: frankt_module,
             frankt_data: frankt_data,
             frankt_handler: {handler_module, handler_fn}
           }
         }
       ) do
    unless function_exported?(handler_module, handler_fn, 2) do
      raise ConfigurationError,
        module: frankt_module,
        message:
          "Frankt is trying to execute an action, but the handler module does not define the appropriate function. Please define a '#{
            handler_fn
          }/2' function in your #{handler_module} module."
    end

    apply(handler_module, handler_fn, [frankt_data, socket])
    socket
  end
end
