defmodule Frankt.TestApplication.FranktChannelTest do
  use Frankt.ChannelCase

  alias Frankt.TestApplication.FranktChannel

  setup do
    {:ok, _, socket} =
      "frankt_test_socket"
      |> socket(%{})
      |> subscribe_and_join(FranktChannel, "frankt:test")

    {:ok, socket: socket}
  end

  test "runs a Frankt action", %{socket: socket} do
    frankt_action(socket, "frankt_actions:redirect", %{})
    assert_push("redirect", %{target: "/"})
  end
end
