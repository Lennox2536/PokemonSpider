defmodule PokemonSpider.PokemonPageSpider do
  def pokemons(doc) do
    Floki.parse_document!(doc)
    |> Floki.find("li.product")
    |> Enum.map(&map_pokemon_html/1)
  end

  defp map_pokemon_html(pokemon_html) do
    %{
      pokemon_id: get_and_increment_id(),
      name: fetch_name(pokemon_html),
      image_url: fetch_image_src(pokemon_html),
      sku: get_and_increment_sku(),
      price: fetch_price(pokemon_html)
    }
  end

  defp fetch_name(pokemon_html) do
    [{_, _, [pokemon_name]}] =
      pokemon_html
      |> Floki.find(".woocommerce-loop-product__title")

    pokemon_name
  end

  defp fetch_image_src(pokemon_html) do
    pokemon_html
    |> Floki.find("img")
    |> Floki.attribute("src")
    |> List.first()
  end

  defp fetch_price(pokemon_html) do
    [{_, _, [_, price]}] =
      pokemon_html
      |> Floki.find(".woocommerce-Price-amount")

    [{_, _, [currency]}] =
      pokemon_html
      |> Floki.find(".woocommerce-Price-currencySymbol")

    "#{price}#{currency}"
  end

  defp get_and_increment_id() do
    get_and_increment_value(:pokemon_id)
  end

  defp get_and_increment_sku() do
    get_and_increment_value(:sku)
  end

  defp get_and_increment_value(key) do
    case Process.get(key) do
      nil ->
        Process.put(key, 2)
        1

      value ->
        Process.put(key, value + 1)
        value
    end
  end
end
