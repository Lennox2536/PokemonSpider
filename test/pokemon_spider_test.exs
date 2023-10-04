defmodule PokemonSpiderTest do
  use ExUnit.Case
  doctest PokemonSpider

  test "greets the world" do
    assert PokemonSpider.hello() == :world
  end
end
