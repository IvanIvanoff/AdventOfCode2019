defmodule Advent1 do
  @moduledoc ~s"""
  https://adventofcode.com/2019/day/1
  """
  @data Advent1.Data.get()

  def sum(input \\ @data) do
    Enum.reduce(input, 0, fn num, acc ->
      fuel = (Float.floor(num / 3) - 2) |> trunc()
      acc + fuel
    end)
  end

  def sum_fuel_needs_fuel(input \\ @data) do
    Enum.reduce(input, 0, fn num, acc ->
      fuel = (Float.floor(num / 3) - 2) |> trunc()
      additional_fuel = fuel_needs_fuel(fuel)

      acc + fuel + additional_fuel
    end)
  end

  defp fuel_needs_fuel(fuel) do
    case (Float.floor(fuel / 3) - 2) |> trunc() do
      value when value <= 0 -> 0
      value -> value + fuel_needs_fuel(value)
    end
  end
end
