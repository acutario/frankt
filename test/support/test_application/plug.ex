defmodule Frankt.TestApplication.Plug do
  @moduledoc false
  @behaviour Frankt.Plug

  alias Phoenix.Channel

  def call(socket, _opts) do
    # Plugs can do anything with the socket as long as it is returned. Even
    # pushing messages!
    Channel.push(socket, "the-plug-is-running", %{})
    socket
  end
end
