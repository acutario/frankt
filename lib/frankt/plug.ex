defmodule Frankt.Plug do
  @moduledoc """
  The Frankt plug specification.

  Frankt plugs must export a `call/2` function which receives the socket and a
  set of options and returns a socket.

  For concrete examples of Frankt plugs, you can take a look at the
  `Frankt.Plug.SetHandler`, `Frankt.Plug.SetGettext` and `Frankt.Plug.ExecuteAction`.
  """

  @callback call(socket :: Phoenix.Socket.t(), opts :: Plug.opts()) :: Phoenix.Socket.t()

  defmacro __using__(_opts) do
    quote do
      @behaviour Frankt.Plug

      import Phoenix.Socket, only: [assign: 3]
    end
  end
end
