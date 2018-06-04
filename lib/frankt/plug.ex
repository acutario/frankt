defmodule Frankt.Plug do
  @moduledoc """
  Defines the required callbacks for Frankt plugs.
  """
  @type opts :: binary | tuple | atom | integer | float | [opts] | %{opts => opts}

  @callback call(socket :: Phoenix.Socket.t(), opts :: opts) :: Phoenix.Socket.t()
end
