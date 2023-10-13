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

defmodule VendingMachinePerqaraSlidingWindow do
  @products %{
    12000 => "Coffee",
    9000 => "Milo",
    7000 => "Cola",
    5000 => "Sosro",
    2000 => "Aqua"
  }

  @valid_denominations [2000, 5000]

  def run(input, products \\ @products, valid_denominations \\ @valid_denominations) do
    with {:ok, sum_of_input} <- filter_and_sum(input, valid_denominations) do
      sorted_product_prices = Map.keys(products) |> Enum.sort(fn a, b -> a > b end)

      buy_products(sum_of_input, sorted_product_prices, products, %{})
    end
  end

  defp filter_and_sum([], _valid_denominations, acc \\ 0), do: {:ok, acc}

  defp filter_and_sum([head | tail], valid_denominations, acc) do
    if head in valid_denominations do
      filter_and_sum(tail, valid_denominations, acc + head)
    else
      {:error, "#{head} is invalid denomination"}
    end
  end

  defp buy_products(balance, [], _products, purchased_products), do: purchased_products

  defp buy_products(
         balance,
         [product_price | rest_of_prices] = sorted_product_prices,
         products,
         purchased_products
       ) do
    if balance >= product_price do
      product_name = Map.get(products, product_price)

      purchased_products = Map.update(purchased_products, product_name, 1, fn n -> n + 1 end)

      buy_products(balance - product_price, sorted_product_prices, products, purchased_products)
    else
      buy_products(balance, rest_of_prices, products, purchased_products)
    end
  end
end
