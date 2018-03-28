defmodule KatterTest do
  use ExUnit.Case
  doctest Katter

  test "greets the world" do
    assert Katter.hello() == :world
  end
end
