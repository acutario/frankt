defmodule Frankt do
  @moduledoc """
  Trigger client-side commands from the server.

  Frankt allows you to define websocket responses that will trigger commands in the clients.
  Responses run on the server and leverage all the Elixir and Phoenix capabilities. A thin JS layer
  applies the desired commands in the clients.

  ## Usage

  Frankt modules must define responses that are triggered by client-side actions.

  ```
  defmodule MyApp.Frankt.Example do
    use Frankt

    defresponse "example:replace-message", fn (params, socket) ->
      push socket, "replace_with", %{html: "<h1>Replaced message</h1>", target: "#message"}
    end
  end
  ```

  Then, you must make sure that the responses are available in the channel by adding the following
  line:

  ```
  # Add this line into your channel module.
  use MyApp.Frankt.Example
  ```

  ## Usage with Gettext

  By default Frankt actions don't use internationalization. If you want your responses to be
  executed under a certain locale, you must set up the Gettext module that must be used by Frankt.

  ```
  defmodule MyApp.Frankt.Example do
    use Frankt, gettext: MyApp.Gettext

    # Define your responses as usual and they will be automatically executed with the adequate
    locale.
  end
  ```

  Frankt will try to get the locale from the `locale` socket assign. You must ensure that this
  assign is set in the socket before executing Frankt responses.

  ## More information and examples

  If you want more information about how to use Frankt, please take a look at the
  [concepts guide](https://hexdocs.pm/frankt/concepts.html) and the
  [examples](https://hexdocs.pm/frankt/examples.html).
  """

  @typedoc """
  Annonymous function that handles responses.

  Handler functions receive two parameters: the first one is the map of parameters sent by the
  client (or empty if none) and the second one is the socket to which the client is connected.

  Handler functions don't have to return anything, as their return value will be discarded. The
  handler function can `push` many actions to the socket so they will be executed in the client. The
  `push` can happen anywhere inside the function, the preferred approach is to push as soon as
  possible in order to provide quick feedback.

  Since handler functions are simply annonymous functions every language rule (such as pattern
  matching) applies.
  """
  @type response_handler :: ((params :: map(), socket :: Phoenix.Socket.t()) -> any())

  defmacro __using__(_opts) do
    quote do
      def handle_in("frankt-action", params = %{"action" => action}, socket) do
        [handler_name, handler_fn] = String.split(action, ":")
        handler_module = Frankt.__handler__(__MODULE__, handler_name)
        gettext = Frankt.__gettext__(__MODULE__)
        data = Map.get(params, "data", %{})

        Frankt.__execute_action__(handler_module, String.to_existing_atom(handler_fn), data, socket, gettext)
        {:noreply, socket}
      end
    end
  end

  @doc false
  def __execute_action__(module, fun, params, socket, gettext) do
    invoke_action = fn ->
      unless function_exported?(module, fun, 2) do
        raise "Frankt is trying to execute an action, but the handler module does not define the appropriate function. Please define a '#{fun}/3' function in your ·#{module} module."
      end
      apply(module, fun, [params, socket])
    end

    if gettext do
      locale =
        case Map.get(socket.assigns, :locale) do
          nil    -> raise "You have configured Frankt to use Gettext for i18n, but the response does not know which locale to use. Please store the desired locale into a `locale` assign in the socket."
          locale -> locale
        end
      Gettext.with_locale(gettext, locale, invoke_action)
    else
      invoke_action.()
    end
  end

  @doc false
  def __handler__(frankt_module, name) when  is_binary(name) do
    handlers = Application.get_env(:frankt, frankt_module)
    if is_nil(handlers) do
      raise "You have not configured any handlers for Frankt. Please set at least one handler in your configuration."
    end
    case get_in(handlers, [:handlers, String.to_existing_atom(name)]) do
      nil -> "Frankt can not find a handler for '#{name}'. Please, chech that you are using the correct name or define a new handler in your configuration."
      handler -> handler
    end
  end

  @doc false
  def __gettext__(frankt_module) do
    :frankt
    |> Application.get_env(frankt_module, [])
    |> Keyword.get(:gettext)
  end

end
