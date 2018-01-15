defmodule Frankt.ActionTest do
  @moduledoc """
  Conveniences for testing Frankt actions.

  This module provides useful convenience functions for testing Frankt actions. The provided
  functions simply wrap the calls provided by Phoenix.  For more information take a look
  at `Phoenix.ChannelTest`.
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
  """
  @spec frankt_action(socket :: Socket.t, action :: String.t, payload :: map()) :: reference()
  defmacro frankt_action(socket, action, payload \\ %{}) do
    quote do
      push(unquote(socket), "frankt-action", %{action: unquote(action), data: unquote(payload)})
    end
  end
end
