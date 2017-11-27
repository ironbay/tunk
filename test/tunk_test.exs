defmodule TunkTest do
  use ExUnit.Case
  doctest Tunk

  test "greets the world" do
    assert Tunk.hello() == :world
  end
end
