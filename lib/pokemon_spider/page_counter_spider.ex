defmodule PokemonSpider.PageCounterSpider do
  def count(doc) do
    {_, _, [page_number]} =
      Floki.parse_document!(doc)
      |> Floki.find("a.page-numbers")
      |> Enum.reverse()
      |> Enum.drop(1)
      |> List.first()

    page_number
    |> String.to_integer()
  end
end
