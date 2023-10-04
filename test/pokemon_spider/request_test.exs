defmodule PokemonSpider.RequestTest do
  use ExUnit.Case
  doctest PokemonSpider.Request

  alias PokemonSpider.Request

  @seconds_mock 1234

  setup do
    System.put_env("seconds_mock", Integer.to_string(@seconds_mock))
  end

  test "should sleep if request limit per second exceeded" do
    refute Process.get(:wait_second_marked)

    for _i <- 1..6 do
      Request.call("some_url")
    end

    assert Process.get(:wait_second_marked)
  end

  test "should carry on if request limit per second not exceeded" do
    refute Process.get(:wait_second_marked)

    for _i <- 1..5 do
      Request.call("some_url")
    end

    refute Process.get(:wait_second_marked)
  end
end
