defmodule PokemonSpider.Request do
  def call(url) do
    %{body: body} = HTTPoison.get!(url)

    body
  end
end
