defmodule Frankt do
  @moduledoc """
  Run client-side actions from the backend.

  Frankt provides a thin layer over Phoenix Channels which allows running client-side actions
  from the backend. Since the logic of those actions lives in the backend, they can leverage all the
  `Elixir` and `Phoenix` capabilities.

  ## Usage

  Frankt modules are actually `Phoenix.Channel` modules with some extra functionality.

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
  import Phoenix.Channel

  alias Frankt.ConfigurationError
  alias Frankt.Plug

  require Logger

  @type response_handler :: (params :: map(), socket :: Phoenix.Socket.t() -> any())

  @callback handlers() :: %{required(String.t()) => module()}
  @callback gettext() :: module() | nil
  @callback handle_error(error :: Exception.t(), socket :: Phoenix.Socket.t(), params :: map()) ::
              Phoenix.Socket.t()
  @callback plugs() :: list(module())

  @pre_plugs [Plug.SetHandler, Plug.SetGettext]
  @post_plugs [Plug.ExecuteAction]

  defmacro __using__(_opts) do
    quote do
      @behaviour Frankt

      def handle_in("frankt-action", params = %{"action" => action}, socket) do
        socket
        |> Frankt.__setup_action__(params, __MODULE__)
        |> Frankt.__run_pipeline__()
      rescue
        error -> handle_error(error, socket, params)
      end

      def handle_error(error, socket, params), do: Frankt.__handle_error__(error, socket, params)

      def gettext, do: nil

      def plugs, do: []

      defoverridable Frankt
    end
  end

  def __setup_action__(socket = %{private: private}, params = %{"action" => action}, module) do
    setup_vars = %{
      frankt_action: action,
      frankt_module: module,
      frankt_data: Map.get(params, "data", %{})
    }

    %{socket | private: Enum.into(setup_vars, private)}
  end

  def __run_pipeline__(socket = %{private: %{frankt_module: module}}) do
    socket =
      [@pre_plugs, module.plugs(), @post_plugs]
      |> List.flatten()
      |> Enum.reduce(socket, &__run_plug__/2)

    {:noreply, socket}
  end

  def __run_plug__({module, opts}, socket), do: module.call(socket, opts)
  def __run_plug__(module, socket), do: __run_plug__({module, nil}, socket)

  @doc false
  def __handle_error__(error, socket, _params) do
    message =
      case error do
        %ConfigurationError{} -> "frankt-configuration-error"
        _ -> "frankt-error"
      end

    :error
    |> Exception.format(error)
    |> Logger.error()

    push(socket, message, %{})
    {:noreply, socket}
  end
end
