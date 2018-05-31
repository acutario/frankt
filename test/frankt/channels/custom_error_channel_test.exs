defmodule Frankt.TestApplication.CustomErrorChannelTest do
  use Frankt.ChannelCase

  alias Frankt.TestApplication.FranktCustomErrorChannel

  @test_socket "frankt_test_socket"
  @test_topic "frankt:test"

  setup do
    {:ok, _, socket} =
      @test_socket
      |> socket(%{})
      |> subscribe_and_join(FranktCustomErrorChannel, @test_topic)

    {:ok, socket: socket}
  end

  describe "Frankt channel with custom error handler" do
    test "runtime errors are handled by the custom error handler", %{
      socket: socket
    } do
      frankt_action(socket, "frankt_actions:break", %{})
      assert_push("custom-error-handled", %{})
    end

    test "configuration errors are handled by the custom error handler", %{
      socket: socket
    } do
      frankt_action(socket, "frankt_actions:non_existing", %{})
      assert_push("custom-error-handled", %{})
    end
  end
end
