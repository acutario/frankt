# Sets the Frankt gettext information for the incoming action.
# The gettext module is stored under the `frankt_module` key in the socket.

defmodule Frankt.Plug.SetGettext do
  @moduledoc false
  use Frankt.Plug

  @impl true
  def call(socket = %{private: private = %{frankt_module: frankt_module}}, _opts) do
    gettext_module = frankt_module.gettext()
    %{socket | private: Map.put(private, :frankt_gettext, gettext_module)}
  end
end
