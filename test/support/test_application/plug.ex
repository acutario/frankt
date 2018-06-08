defmodule Frankt.TestApplication.Plug do
  @moduledoc false
  @behaviour Frankt.Plug

  alias Phoenix.Channel

  def call(socket, %{message: message}) do
    # Plugs can do anything with the socket as long as it is returned. Even
    # pushing messages!
    Channel.push(socket, message, %{})
    socket
  end
end
