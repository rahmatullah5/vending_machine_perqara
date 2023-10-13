defmodule VendingMachinePerqara do
  @moduledoc """
  This module simulates a vending machine transaction process, allowing purchase of products
  based on the input list of currency denominations. It validates the currency, sums up the valid
  denominations, and then buys products till it exhausts the amount.

  ## Examples

      iex> VendingMachinePerqara.run([5000, 2000, 5000])
      %{"Coffee" => 1}

      iex> VendingMachinePerqara.run([3000])
      {:error, "3000 is invalid denomination"}
  """

  # Static list of products with their respective prices.
  @products [
    {12000, "Coffee"},
    {9000, "Milo"},
    {7000, "Cola"},
    {5000, "Sosro"},
    {2000, "Aqua"}
  ]

  # Allowed currency denominations.
  @valid_denominations [2000, 5000]

  @spec run(maybe_improper_list()) :: {:error, <<_::64, _::_*8>>} | map()
  def run(input) do
    # Main entry point that takes a list of currency denominations,
    # filters and sums up valid denominations, and attempts to purchase products.
    with {:ok, sum_of_input} <- filter_and_sum(input) do
      buy_products(sum_of_input, %{})
    end
  end

  # Header for function with default parameters.
  defp filter_and_sum(list, acc \\ 0)

  # When list is empty, return the accumulator.
  defp filter_and_sum([], acc), do: {:ok, acc}

  defp filter_and_sum([head | _tail], _acc) when head not in @valid_denominations,
    # Error on invalid denomination.
    do: {:error, "#{head} is invalid denomination"}

  # Sum valid denominations.
  defp filter_and_sum([head | tail], acc), do: filter_and_sum(tail, acc + head)

  # The following functions use metaprogramming to define multiple function clauses at compile time,
  # one for each product, checking if the balance is sufficient to buy the product.
  for {price, name} <- @products do
    defp buy_products(balance, purchased_products) when balance >= unquote(price) do
      # If enough balance, "buy" the product by deducting price and incrementing the product count.
      buy_products(
        balance - unquote(price),
        Map.update(purchased_products, unquote(name), 1, fn n -> n + 1 end)
      )
    end
  end

  # Return final list of purchased products.
  defp buy_products(_balance, purchased_products), do: purchased_products
end

{:error, "1000 is invalid denomination"} = VendingMachinePerqara.run([1000]) |> IO.inspect()
%{"Aqua" => 1} = VendingMachinePerqara.run([2000]) |> IO.inspect()
%{"Aqua" => 2} = VendingMachinePerqara.run([2000, 2000]) |> IO.inspect()
%{"Cola" => 1} = VendingMachinePerqara.run([5000, 2000]) |> IO.inspect()
%{"Milo" => 1} = VendingMachinePerqara.run([5000, 5000]) |> IO.inspect()

%{"Coffee" => 1, "Sosro" => 1} =
  VendingMachinePerqara.run([5000, 5000, 5000, 2000]) |> IO.inspect()

defmodule VendingMachinePerqaraSlidingWindow do
  @moduledoc """
  Similar to `VendingMachinePerqara`, this module performs vending machine transactions. However,
  it introduces a more dynamic way of handling the products and their prices. Rather than having a
  fixed list, it operates on a map of products passed as an argument, which allows for more flexible
  vending operations. It uses a 'sliding window' approach to iterate over the sorted product prices.

  ## Examples

      iex> products = %{15000 => "Tea", 12000 => "Coffee", 5000 => "Biscuit"}
      iex> VendingMachinePerqaraSlidingWindow.run([5000, 2000, 12000], products)
      %{"Coffee" => 1, "Biscuit" => 1}

      iex> VendingMachinePerqaraSlidingWindow.run([1000], products)
      {:error, "1000 is invalid denomination"}
  """

  # Static map of products with their respective prices.
  @products %{
    12000 => "Coffee",
    9000 => "Milo",
    7000 => "Cola",
    5000 => "Sosro",
    2000 => "Aqua"
  }

  # Default allowed currency denominations.
  @valid_denominations [2000, 5000]

  def run(input, products \\ @products, valid_denominations \\ @valid_denominations) do
    # Main function; takes currency denominations, optional product map, and denominations list.
    # Purchases products starting from the highest price affordable.
    with {:ok, sum_of_input} <- filter_and_sum(input, valid_denominations) do
      sorted_product_prices = Map.keys(products) |> Enum.sort(fn a, b -> a > b end)
      buy_products(sum_of_input, sorted_product_prices, products, %{})
    end
  end

  # Header for function with default parameters.
  defp filter_and_sum(list, valid_denominations, acc \\ 0)

  # Return accumulator when list is empty.
  defp filter_and_sum([], _valid_denominations, acc), do: {:ok, acc}

  defp filter_and_sum([head | tail], valid_denominations, acc) do
    # Validate denomination and continue summing if valid.
    if head in valid_denominations do
      filter_and_sum(tail, valid_denominations, acc + head)
    else
      # Error on invalid denomination.
      {:error, "#{head} is invalid denomination"}
    end
  end

  # Return when no more products to check.
  defp buy_products(_balance, [], _products, purchased_products), do: purchased_products

  defp buy_products(
         # Purchase products; if balance is sufficient, buy and move to the next with remaining balance.
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

{:error, "1000 is invalid denomination"} =
  VendingMachinePerqaraSlidingWindow.run([1000]) |> IO.inspect()

%{"Aqua" => 1} = VendingMachinePerqaraSlidingWindow.run([2000]) |> IO.inspect()
%{"Aqua" => 2} = VendingMachinePerqaraSlidingWindow.run([2000, 2000]) |> IO.inspect()
%{"Cola" => 1} = VendingMachinePerqaraSlidingWindow.run([5000, 2000]) |> IO.inspect()
%{"Milo" => 1} = VendingMachinePerqaraSlidingWindow.run([5000, 5000]) |> IO.inspect()

%{"Coffee" => 1, "Sosro" => 1} =
  VendingMachinePerqaraSlidingWindow.run([5000, 5000, 5000, 2000]) |> IO.inspect()
