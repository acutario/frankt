defmodule Frankt do
  @moduledoc """
  Run client-side actions from the backend.

  Frankt provides a thin layer over Phoenix channels which allows running client-side actions
  from the backend. Since the logic of those actions lives in the backend, they can leverage all the
  [`Elixir`][1] and `Phoenix` capabilities.

  ## Basic Usage

  As explained before Frankt channels are actually Phoenix channels which `use Frankt`. You can find
  more information about setting up channels and wiring them into sockets in the `Phoenix.Channel`
  docs.

  Frankt channels implement the `Frankt` behaviour and therefore must export a `handlers/0`
  function which returns a map containing the modules which will handle incoming actions. We call
  those modules "_action handlers_". Action handlers would be the Frankt equivalent to Phoenix
  controllers.

  This example shows a very basic Frankt channel which allows any connection and registers a single
  action handler.

      defmodule MyApp.FranktChannel do
        use Phoenix.Channel
        use Frankt

        def join(_topic, _payload, socket), do: {:ok, socket}

        def handlers, do: %{"example_actions" => MyApp.FranktExampleActions}
      end

  When messages arrive to our channel, Frankt automatically checks if there is any matching action
  handler registered and runs it.

  This example shows a very basic action handler with a single action. Action handlers can run
  business logic, render templates, push or broadcast messages into the channel, etc.

      defmodule MyApp.FranktExampleActions do
        import Phoenix.Channel
        import MyApp.Router.Helpers

        def redirect_to_home(_params, socket), do: push(socket, "redirect", %{target: "/"})
      end

  Frankt channels can also customize other advanced aspects such as i18n, plugs and error handlers.

  ## Advanced Usage

  ### Setting up i18n

  Frankt can optionally use `Gettext` to internationalize rendered templated and messages just like
  Phoenix controllers do. To set up the `Gettext` integration, your Frankt channel must implement
  the `gettext/0` callback.

  We can add the following line to our example Frankt channel:

      def gettext, do: MyApp.Gettext

  Now the action handlers registered in our Frankt channel will automatically use `MyApp.Gettext`
  to internationalize texts.

  To know which locale to use in the action handlers Frankt needs a `locale` assigned into the
  socket. A great place to assign a locale to the socket would be a Frankt plug.

  ### Setting up plugs

  Frankt channels can run certain modules to modify the socket before the action handler is executed.
  Those modules are known as Frankt plugs because they are somewhat similar to our beloved `Plug`.

  We can register plugs in our Frankt channel by implementing the `plugs` callback:

      def plugs, do: [MyApp.FranktLocalePlug]

  Frankt plugs implement the `Frankt.Plug` behaviour so they must to export a `call/2`
  function which returns a `Phoenix.Socket`.

  The following example shows a very basic plug that could set up the locale to use in our action
  handlers.

      defmodule MyApp.FranktLocalePlug do
        use Frankt.Plug

        @impl true
        def call(socket = %{assigns: assigns}, opts) do
          assign(socket, :locale, assigns.current_user.locale)
        end
      end

  Just like `Plug`, Frankt plugs are run sequentially and each one receives the socket returned by
  the previous plug.

  Frankt functionality is also implemented as plugs. You can take a look at them into the
  `lib/frankt/plug` directory to see some examples.

  ### Handling errors

  Frankt catches any errors thay may happen while handling an incoming message. By default, those
  errors are handled by pushing a `frankt-configuration-error` (in the case of
  `Frankt.ConfigurationError`) or a `frankt-error` (in other cases) to the socket. Those messages
  can be used to provide appropriate feedback in the client.

  If you want to customize how errors are handled, you can implement the `handle_error/3` callback.
  The `handle_error/3` callback receives the rescued error, the socket and the params of the
  incoming message.

  The following example shows a very basic error handler that redirects to the index in case of
  any errors.

      def handle_error(%Frankt.ConfigurationError{}, socket, _params) do
        push(socket, "redirect", %{target: "/"})
        {:noreply, socket}
      end

  If you choose to implement a custom error handler for your Frankt channel, keep in mind that it
  must return some of the values specified in `c:Phoenix.Channel.handle_in/3`.

  [1]: https://hexdocs.pm/elixir/Kernel.html
  """

  import Phoenix.Channel

  alias Frankt.ConfigurationError
  alias Frankt.Plug

  require Logger

  @callback handlers() :: %{required(String.t()) => module()}
  @callback gettext() :: module()
  @callback handle_error(error :: Exception.t(), socket :: Phoenix.Socket.t(), params :: map()) ::
              {:noreply, Phoenix.Socket.t()}
              | {:reply, Phoenix.Channel.reply(), Phoenix.Socket.t()}
              | {:stop, reason :: term, Phoenix.Socket.t()}
              | {:stop, reason :: term, Phoenix.Channel.reply(), Phoenix.Socket.t()}
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
