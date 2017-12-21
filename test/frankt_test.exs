defmodule FranktTest do
  use ExUnit.Case
  doctest Frankt

  test "greets the world" do
    assert Frankt.hello() == :world
  end
end
