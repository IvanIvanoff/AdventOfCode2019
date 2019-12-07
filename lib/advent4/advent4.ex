defmodule Advent4 do
  def run(low, high) do
    low..high
    |> Enum.reduce(0, fn number, count ->
      list = Integer.to_charlist(number)

      if not_decreasing?(list) and has_same_neighbour?(list) do
        count + 1
      else
        count
      end
    end)
  end

  def run2(low, high) do
    low..high
    |> Enum.reduce(0, fn number, count ->
      list = Integer.to_charlist(number)

      if not_decreasing?(list) and 2 in same_neighbour_strike_lengths(list) do
        count + 1
      else
        count
      end
    end)
  end

  defp has_same_neighbour?([]), do: false
  defp has_same_neighbour?([_]), do: false
  defp has_same_neighbour?([a, a | rest]), do: true
  defp has_same_neighbour?([a, b | rest]), do: has_same_neighbour?([b | rest])

  def same_neighbour_strike_lengths([num | list]) do
    # + 'd' is hack to handle if the strike ends with the last digit
    {strike_lengths, _, _, _} =
      (list ++ 'd')
      |> Enum.reduce(
        {[], false, 0, num},
        fn
          n, {strike_lengths, _in_strike = false, _strike_length, n} ->
            {strike_lengths, true, 2, n}

          n, {strike_lengths, _in_strike = false, _strike_length, _last_num} ->
            {strike_lengths, false, 1, n}

          n, {strike_lengths, _in_strike = true, length, n} ->
            {strike_lengths, true, length + 1, n}

          n, {strike_lengths, true, length, _last_num} ->
            {[length | strike_lengths], false, 1, n}
        end
      )

    strike_lengths |> IO.inspect(label: "#{inspect([num | list])}", limit: :infinity)
  end

  defp has_same_neighbour_no_more_than_2?([]), do: false
  defp has_same_neighbour_no_more_than_2?([_]), do: false
  defp has_same_neighbour_no_more_than_2?([a, a, a | rest]), do: false
  defp has_same_neighbour_no_more_than_2?([a, a | rest]), do: true
  defp has_same_neighbour_no_more_than_2?([a, b | rest]), do: has_same_neighbour?([b | rest])

  defp not_decreasing?([]), do: true
  defp not_decreasing?([_]), do: true
  defp not_decreasing?([a, b | rest]) when a <= b, do: not_decreasing?([b | rest])
  defp not_decreasing?(_), do: false
end
