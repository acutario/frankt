defmodule Frankt.ActionTest do
  @moduledoc """
  Conveniences for testing Frankt actions.
  You can `import Frankt.ActionTest` in your test cases having easy access to the helpers provided
  by this module.

  Frankt tests are channel tests, so the same helpers and principles apply. For more information
  take a look at `Phoenix.ChannelTest`.
  """

  @doc """
  Invoke a Frankt action.

  Underneath, this function pushes a message into the Frankt channel so it can be dispatched by the
  corresponding action.
  After the message is pushed into the Frankt channel, you can check the response by using
  `Phoenix.ChannelTest.assert_push/3`.
  """
  @spec frankt_action(socket :: Phoenix.Socket.t(), action :: String.t(), payload :: map()) ::
          reference()
  defmacro frankt_action(socket, action, payload \\ %{}) do
    quote do
      push(unquote(socket), "frankt-action", %{action: unquote(action), data: unquote(payload)})
    end
  end
end
