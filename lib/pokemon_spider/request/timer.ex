defmodule PokemonSpider.Request.Timer do
  def seconds() do
    :os.system_time(:seconds)
  end
end
