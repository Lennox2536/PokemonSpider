defmodule PokemonSpider.Request do
  @limit_per_sec 5

  alias PokemonSpider.Request.Timer

  def call(url) do
    check_limit()

    case HTTPoison.get(url) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        body
      _ ->
        {:error}
    end
  end

  defp check_limit() do
    request_number = find_or_create_request_number()
    second_marked = find_or_create_second_marked()

    handle_limit(request_number, Timer.seconds(), second_marked)
  end

  defp handle_limit(request_number, second_marked, second_marked)
       when request_number >= @limit_per_sec do
    Process.put(:wait_second_marked, second_marked)
    Process.sleep(1000)
    Process.put(:second_marked, Timer.seconds())
    Process.put(:request_number, 1)
  end

  defp handle_limit(request_number, _current_seconds, _second_marked) do
    Process.put(:request_number, request_number + 1)
    Process.put(:second_marked, Timer.seconds())
  end

  defp find_or_create_request_number(value \\ 0) do
    case Process.get(:request_number) do
      nil ->
        Process.put(:request_number, value)
        value

      request_number ->
        request_number
    end
  end

  defp find_or_create_second_marked(second \\ Timer.seconds()) do
    case Process.get(:second_marked) do
      nil ->
        Process.put(:second_marked, second)
        second

      second ->
        second
    end
  end
end
