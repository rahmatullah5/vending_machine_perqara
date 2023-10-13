defmodule VendingMachinePerqaraTest do
  use ExUnit.Case
  doctest VendingMachinePerqara

  describe "VendingMachinePerqara" do
    test "returns an error when an invalid denomination is input" do
      assert {:error, _} = VendingMachinePerqara.run([3000])
    end

    test "returns a map of products that can be purchased with the valid denominations provided" do
      assert %{"Aqua" => 1} = VendingMachinePerqara.run([2000])

      assert %{"Aqua" => 2} = VendingMachinePerqara.run([2000, 2000])

      assert %{"Cola" => 1} = VendingMachinePerqara.run([5000, 2000])

      assert %{"Milo" => 1} = VendingMachinePerqara.run([5000, 5000])

      assert %{"Coffee" => 1, "Sosro" => 1} = VendingMachinePerqara.run([5000, 5000, 5000, 2000])

      assert %{"Coffee" => 1} = VendingMachinePerqara.run([2000, 5000, 5000])
      assert %{"Coffee" => 1, "Aqua" => 1} = VendingMachinePerqara.run([2000, 5000, 2000, 5000])
    end
  end
end

defmodule VendingMachinePerqaraSlidingWindowTest do
  use ExUnit.Case

  describe "VendingMachinePerqaraSlidingWindow" do
    test "returns an error when an invalid denomination is input" do
      assert {:error, _} = VendingMachinePerqaraSlidingWindow.run([1000])
    end

    test "returns a map of products that can be purchased with the valid denominations provided" do
      assert %{"Aqua" => 1} = VendingMachinePerqaraSlidingWindow.run([2000])

      assert %{"Aqua" => 2} = VendingMachinePerqaraSlidingWindow.run([2000, 2000])

      assert %{"Cola" => 1} = VendingMachinePerqaraSlidingWindow.run([5000, 2000])

      assert %{"Milo" => 1} = VendingMachinePerqaraSlidingWindow.run([5000, 5000])

      assert %{"Coffee" => 1, "Sosro" => 1} =
               VendingMachinePerqaraSlidingWindow.run([5000, 5000, 5000, 2000])

      assert %{"Coffee" => 1} = VendingMachinePerqaraSlidingWindow.run([5000, 5000, 2000])

      assert %{"Coffee" => 1, "Aqua" => 1} =
               VendingMachinePerqaraSlidingWindow.run([5000, 2000, 5000, 2000])
    end

    test "returns an empty map when not enough money is provided for any product" do
      custom_products = %{
        3000 => "Custom Drink",
        4000 => "Custom Snack"
      }

      assert %{} =
               VendingMachinePerqaraSlidingWindow.run(
                 [2000],
                 custom_products
               )
    end

    test "returns the correct products even when custom products and denominations are used" do
      custom_products = %{
        3000 => "Custom Drink",
        4000 => "Custom Snack"
      }

      custom_denominations = [1000, 2000]

      assert %{"Custom Drink" => 1} =
               VendingMachinePerqaraSlidingWindow.run(
                 [1000, 2000],
                 custom_products,
                 custom_denominations
               )

      assert %{"Custom Snack" => 1, "Custom Drink" => 1} =
               VendingMachinePerqaraSlidingWindow.run(
                 [2000, 2000, 1000, 2000],
                 custom_products,
                 custom_denominations
               )
    end
  end
end
