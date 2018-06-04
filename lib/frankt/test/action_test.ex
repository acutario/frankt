defmodule Frankt.ActionTest do
  @moduledoc """
  Conveniences for testing Frankt actions.

  Frankt tests are actually channel tests. For more information take a look at
  `Phoenix.ChannelTest`.
  """

  @doc false
  defmacro __using__(_opts) do
    quote do
      import Frankt.ActionTest
    end
  end

  @doc """
  Call a Frankt action.

  Pushes a mesasge into the channel which triggers the Frankt `handle_in/3` function and then
  dispatches to the corresponding action.
  After pushing the message to Frankt you can check the response by using
  `Phoenix.ChannelTest.assert_push/3`.
  """
  @spec frankt_action(socket :: Socket.t(), action :: String.t(), payload :: map()) :: reference()
  defmacro frankt_action(socket, action, payload \\ %{}) do
    quote do
      push(unquote(socket), "frankt-action", %{action: unquote(action), data: unquote(payload)})
    end
  end
end
