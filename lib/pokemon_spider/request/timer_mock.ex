defmodule PokemonSpider.Request.TimerMock do
  def seconds() do
    System.get_env("seconds_mock")
  end
end
