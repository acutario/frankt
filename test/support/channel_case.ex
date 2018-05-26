defmodule Frankt.ChannelCase do
  use ExUnit.CaseTemplate

  using do
    quote do
      # Import conveniences for testing with channels
      use Phoenix.ChannelTest
      use Frankt.ActionTest

      # The default endpoint for testing
      @endpoint Frankt.TestApplication.Endpoint
    end
  end
end
