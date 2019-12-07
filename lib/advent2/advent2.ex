defmodule Advent2 do
  @data Advent2.Data.get()

  def find_noun_verb(input \\ @data, expected) do
    pairs = for x <- 0..99, y <- 0..99, do: {x, y}
    do_find_noun_verb(input, expected, pairs)
  end

  def do_find_noun_verb(input, expected, [{x, y} | rest_pairs]) do
    input = input |> List.update_at(1, fn _ -> x end) |> List.update_at(2, fn _ -> y end)

    case do_run(input, input) do
      [^expected | _] -> {x, y, x * 100 + y}
      _ -> do_find_noun_verb(input, expected, rest_pairs)
    end
  end

  def run(input \\ @data) do
    input = input |> List.update_at(1, fn _ -> 12 end) |> List.update_at(2, fn _ -> 2 end)
    do_run(input, input)
  end

  def do_run([1, a, b, c | rest], state) do
    state = List.update_at(state, c, fn _ -> Enum.at(state, a) + Enum.at(state, b) end)
    do_run(rest, state)
  end

  def do_run([2, a, b, c | rest], state) do
    state = List.update_at(state, c, fn _ -> Enum.at(state, a) * Enum.at(state, b) end)
    do_run(rest, state)
  end

  def do_run([99 | _], state) do
    state
  end
end
