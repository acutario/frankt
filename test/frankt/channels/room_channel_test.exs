defmodule Frankt.TestApplication.FranktChannelTest do
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

  test "runs a Frankt action", %{socket: socket} do
    frankt_action(socket, "frankt_actions:redirect", %{})
    assert_push("redirect", %{target: "/"})
  end

  test "invokes a non existing handler", %{socket: socket} do
    frankt_action(socket, "non_existing_handler:non_existing", %{})
    assert_push("frankt-error", %{})
  end

  test "invokes a non existing action", %{socket: socket} do
    frankt_action(socket, "frankt_actions:non_existing", %{})
    assert_push("frankt-error", %{})
  end
end
