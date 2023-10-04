defmodule PokemonSpider do
  alias PokemonSpider.Request
  alias PokemonSpider.PageCounterSpider
  alias PokemonSpider.PokemonPageSpider

  @base_url "https://scrapeme.live/shop/"

  def hello do
    :world
  end

  def get_pokemons() do
    page_number = get_page_number()

    pokemon_lists = for page_number <- 1..page_number, into: [] do
      @base_url
      |> append_page_number(page_number)
      |> Request.call()
      |> PokemonPageSpider.pokemons()
    end

    File.write!("output/result.json", Poison.encode!(List.flatten(pokemon_lists)), [:binary])
  end

  defp get_page_number() do
    Request.call(@base_url)
    |> PageCounterSpider.count()
  end

  defp append_page_number(url, 1) do
    url
  end

  defp append_page_number(url, number) do
    "#{url}page/#{number}/"
  end
end
