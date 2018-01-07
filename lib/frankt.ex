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

  defmacro __using__(opts) do
    quote do
      Module.register_attribute __MODULE__, :responses, accumulate: true
      Module.put_attribute __MODULE__, :gettext, unquote(Keyword.get(opts, :gettext))

      import Frankt, only: [defresponse: 2]

      @before_compile unquote(__MODULE__)
    end
  end

  @doc """
  Used to define a response. It generates the code that call the response
  handler `function` when a `message` is received.
  """
  defmacro defresponse(message, function) do
    quote do
      Module.put_attribute(__MODULE__, :responses, unquote(message))

      def execute_response(unquote(message), params, socket) do
        Frankt.execute_response(unquote(function), params, socket, @gettext)
      end
    end
  end

  # Before the compilation takes place we need to generate the module's `use`
  # handler so it can be used inside the Frankt channel with the response
  # handlers exported correctly.

  # It's important to point that this process should be done just before the
  # compilation takes place to:
  #   * Be able to generate a bit more of code that go into the compilation
  #   * Be able to read responses storage to kow which ones needs to inject in the
  #     socket channel.
  defmacro __before_compile__(_) do
    quote do
      defmacro __using__(_) do
        Enum.map(@responses, fn message ->
          quote do
            def handle_in(unquote(message), params, socket) do
              unquote(__MODULE__).execute_response(unquote(message), params, socket)
            end
          end
        end)
      end
    end
  end

  @doc """
  Build the topic name for the Frankt channel.

  The topic name is used when connecting clients to Frankt. It can also be used in other
  circumstances such broadcasting server-side updates for certain users.

  The `client` variable can be any value used to identify each connection (for example the
  connected user ID). This variable will be base16 encoded for privacy.
  """
  @spec topic_name(client :: String.t()) :: String.t()
  def topic_name(client), do: "frankt:#{:md5 |> :crypto.hash(client) |> Base.encode16()}"

  @doc false
  def execute_response(function, params, socket, nil) do
    function.(params, socket)
    {:noreply, socket}
  end
  def execute_response(function, params, socket, gettext) do
    Gettext.with_locale(gettext, get_locale(socket), fn ->
      function.(params, socket)
      {:noreply, socket}
    end)
  end

  defp get_locale(socket) do
    case Map.get(socket.assigns, :locale) do
      nil    -> raise "You have configured Frankt to use Gettext for i18n, but the response does not know which locale to use. Please store the desired locale into a `locale` assign in the socket."
      locale -> locale
    end
  end

end
