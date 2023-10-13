# Vending Machine Project

This repository contains the implementation of a vending machine simulation for a senior backend engineer position at Perqara. The vending machine has a specific product catalog and accepts only certain denominations. It selects products to dispense based on the total amount of money inserted, starting from the most expensive product affordable with the input amount.

## Product Catalog

The vending machine has the following default products available:

| Item   | Price (in Rp) |
| ------ | ------------- |
| Aqua   | 2000          |
| Sosro  | 5000          |
| Cola   | 7000          |
| Milo   | 9000          |
| Coffee | 12000         |

## Rules

- The vending machine accepts only denominations of Rp. 5000 and Rp. 2000.
- Products are selected starting from the most expensive to the cheapest available based on the total input amount.
- If the inserted money is not in the specified denominations, the machine will reject the input, resulting in an 'invalid denomination' error.

## Implementation

The project is implemented in Elixir and contains two main modules:

- `VendingMachinePerqara`: Handles the logic for filtering and summing valid denominations, purchasing products, and returning an error for invalid denominations.
- `VendingMachinePerqaraSlidingWindow`: An extension that allows dynamic handling of product catalogs and uses a sliding window mechanism to process purchases.

## Test Cases

The following test cases demonstrate the expected outputs for various inputs:

- `[2000]` → output = 1 Aqua
- `[2000, 2000]` → output = 2 Aqua
- `[5000, 2000]` → output = 1 Cola
- `[1000]` → output = invalid denomination (error)
- `[5000, 5000]` → output = 1 Milo
- `[5000, 5000, 5000, 2000]` → output = 1 Coffee, 1 Sosro

## Running the Tests

Explain here how to run the automated tests for this system. Mention any prerequisites or dependencies necessary for testing.

```bash
# Example:
mix test
Compiling 1 file (.ex)
........
Finished in 0.03 seconds (0.00s async, 0.03s sync)
2 doctests, 6 tests, 0 failures

```
