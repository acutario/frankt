defmodule Frankt.TestApplication.GettextChannelTest do
  use Frankt.ChannelCase

  alias Frankt.TestApplication.FranktGettextChannel, as: Channel

  @test_socket "frankt_test_socket"
  @test_topic "frankt:test"

  setup do
    {:ok, _, socket} =
      @test_socket
      |> socket(%{})
      |> subscribe_and_join(Channel, @test_topic)

    {:ok, socket: socket}
  end

  describe "Frankt channel with gettext" do
    test "pushes an error when invoking an action handler without specifying locale", %{
      socket: socket
    } do
      frankt_action(socket, "frankt_actions:redirect", %{})
      assert_push("frankt-configuration-error", %{})
    end
  end
end
