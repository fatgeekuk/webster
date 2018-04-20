defmodule WebsterServerTest do
  use ExUnit.Case
  doctest WebsterServer

  test "greets the world" do
    assert WebsterServer.hello() == :world
  end
end
