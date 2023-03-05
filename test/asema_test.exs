defmodule AsemaTest do
  use ExUnit.Case
  doctest Asema

  test "greets the world" do
    assert Asema.hello() == :world
  end
end
