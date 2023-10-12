defmodule VendingMachinePerqara do
  @moduledoc """
  Documentation for `VendingMachinePerqara`.
  """

  @products [
    {12000, "Coffee"},
    {9000, "Milo"},
    {7000, "Cola"},
    {5000, "Sosro"},
    {2000, "Aqua"}
  ]

  @valid_denominations [2000, 5000]

  @spec run(maybe_improper_list()) :: {:error, <<_::64, _::_*8>>} | map()
  def run(input) do
    with {:ok, sum_of_input} <- filter_and_sum(input) do
      buy_products(sum_of_input, %{})
    end
  end

  defp filter_and_sum([], acc \\ 0), do: {:ok, acc}

  defp filter_and_sum([head | _tail], _acc) when head not in @valid_denominations,
    do: {:error, "#{head} is invalid denomination"}

  defp filter_and_sum([head | tail], acc), do: filter_and_sum(tail, acc + head)

  for {price, name} <- @products do
    defp buy_products(balance, purchased_products) when balance >= unquote(price) do
      buy_products(
        balance - unquote(price),
        Map.update(purchased_products, unquote(name), 1, fn n -> n + 1 end)
      )
    end
  end

  defp buy_products(_balance, purchased_products), do: purchased_products
end
