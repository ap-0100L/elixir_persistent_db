defmodule PersistentDbTest do
  use ExUnit.Case
  doctest PersistentDb

  test "greets the world" do
    assert PersistentDb.ping() == :pong
  end
end
