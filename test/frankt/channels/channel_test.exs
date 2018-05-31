defmodule Frankt.TestApplication.ChannelTest do
  use Frankt.ChannelCase

  alias Frankt.TestApplication.FranktChannel

  @test_socket "frankt_test_socket"
  @test_topic "frankt:test"

  setup do
    {:ok, _, socket} =
      @test_socket
      |> socket(%{})
      |> subscribe_and_join(FranktChannel, @test_topic)

    {:ok, socket: socket}
  end

  describe "Frankt channel" do
    test "invoking an action handler results in a proper message", %{socket: socket} do
      frankt_action(socket, "frankt_actions:redirect", %{})
      assert_push("redirect", %{target: "/"})
    end

    test "invoking an action handler with faulty logic results in an error message", %{
      socket: socket
    } do
      frankt_action(socket, "frankt_actions:break", %{})
      assert_push("frankt-error", %{})
    end

    test "invoking a non existing handler results in a configuration error message", %{
      socket: socket
    } do
      frankt_action(socket, "non_existing_handler:non_existing", %{})
      assert_push("frankt-configuration-error", %{})
    end

    test "invoking a non existing action results in a configuration error message", %{
      socket: socket
    } do
      frankt_action(socket, "frankt_actions:non_existing", %{})
      assert_push("frankt-configuration-error", %{})
    end
  end
end
