defmodule Frankt do
  @moduledoc """
  This module is the base used to define frankenstein responses using it's own
  DSL to register responses to messages.

  Usage example:

      defmodule Frankt.Example do
        use App.Web, :frankt

        defresponse "example", fn(params, socket) ->
          # do whathever is needed
          push socket, "replace_with", %{html: html, target: target}
        end
      end
  """

  @doc """
  This `use` macro ensures that all code needed by the DSL is loaded and
  imported.
  """
  defmacro __using__(_) do
    quote do
      Module.register_attribute __MODULE__, :responses, accumulate: true

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
          unquote(function).(params, socket)
        {:noreply, socket}
      end
    end
  end

  @doc """
  Before the compilation takes place we need to generate the module's `use`
  handler so it can be used inside the Frankt channel with the response
  handlers exported correctly.

  It's important to point that this process should be done just before the
  compilation takes place to:
    * Be able to generate a bit more of code that go into the compilation
    * Be able to read responses storage to kow which ones needs to inject in the
      socket channel.
  """
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

  def frankt_topic_name(client) do
    topic_hash = :crypto.hash(:md5, client)
    "frankt:#{Base.encode16(topic_hash)}"
  end
end
