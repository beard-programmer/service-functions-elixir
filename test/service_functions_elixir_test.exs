defmodule ServiceFunctionsElixirTest do
  use ExUnit.Case
  doctest ServiceFunctionsElixir

  test "greets the world" do
    assert ServiceFunctionsElixir.hello() == :world
  end
end
