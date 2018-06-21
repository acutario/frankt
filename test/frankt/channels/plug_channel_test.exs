defmodule Frankt.TestApplication.PlugChannelTest do
  use Frankt.ChannelCase

  alias Frankt.TestApplication.FranktPlugChannel

  @test_socket "frankt_test_socket"
  @test_topic "frankt:test"

  setup do
    {:ok, _, socket} =
      @test_socket
      |> socket(%{})
      |> subscribe_and_join(FranktPlugChannel, @test_topic)

    {:ok, socket: socket}
  end

  describe "Frankt channel with a plug" do
    test "executes the plug when handling actions", %{socket: socket} do
      frankt_action(socket, "frankt_actions:redirect", %{})
      assert_push("the-plug-is-running", %{})
    end
  end
end
