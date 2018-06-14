defmodule Frankt.ChannelCase do
  @moduledoc false

  use ExUnit.CaseTemplate

  using do
    quote do
      # Import conveniences for testing with channels
      use Phoenix.ChannelTest

      import Frankt.ActionTest

      # The default endpoint for testing
      @endpoint Frankt.TestApplication.Endpoint
    end
  end
end
