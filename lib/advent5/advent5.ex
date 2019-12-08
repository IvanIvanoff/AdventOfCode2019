defmodule Advent5 do
  require Logger
  @data Advent5.Data.get2()

  def run(input \\ @data) do
    do_run(input, input, 0)
  end

  # OPCODE 1 - SUM
  def do_run([opcode, a, b, pos | rest], state, count) when rem(opcode, 100) == 1 do
    Logger.debug(inspect({1, opcode, a, b, pos}))
    count = count + 4
    modeArg1 = opcode |> div(100) |> rem(10)
    modeArg2 = opcode |> div(1000) |> rem(10)

    value = get_value(state, modeArg1, a) + get_value(state, modeArg2, b)
    state = List.update_at(state, pos, fn _ -> value end)
    rest = if pos < count, do: rest, else: Enum.drop(state, count)
    do_run(rest, state, count)
  end

  # OPCODE 2 - MULTIPLY
  def do_run([opcode, a, b, pos | rest], state, count) when rem(opcode, 100) == 2 do
    Logger.debug(inspect({2, opcode, a, b, pos}))

    count = count + 4
    modeArg1 = opcode |> div(100) |> rem(10)
    modeArg2 = opcode |> div(1000) |> rem(10)

    value = get_value(state, modeArg1, a) * get_value(state, modeArg2, b)
    state = List.update_at(state, pos, fn _ -> value end)
    rest = if pos < count, do: rest, else: Enum.drop(state, count)
    do_run(rest, state, count)
  end

  # OPCODE 3 - INPUT
  def do_run([opcode, pos | rest], state, count) when rem(opcode, 100) == 3 do
    Logger.debug(inspect({3, opcode, pos}))

    count = count + 2
    state = List.update_at(state, pos, fn _ -> input() end)
    rest = if pos < count, do: rest, else: Enum.drop(state, count)
    do_run(rest, state, count)
  end

  # OPCODE 4 - OUTPUT
  def do_run([opcode, arg | rest], state, count) when rem(opcode, 100) == 4 do
    Logger.debug(inspect({4, opcode, arg}))

    modeArg = opcode |> div(100) |> rem(10)
    get_value(state, modeArg, arg) |> output

    do_run(rest, state, count + 2)
  end

  # OPCODE 5 - jump if non-zero
  def do_run([opcode, val, pos | rest], state, count) when rem(opcode, 100) == 5 do
    Logger.debug(inspect({5, opcode, val, pos}))

    modeArg1 = opcode |> div(100) |> rem(10)
    modeArg2 = opcode |> div(1000) |> rem(10)
    pos = get_value(state, modeArg2, pos)

    case get_value(state, modeArg1, val) do
      0 ->
        do_run(rest, state, count + 3)

      _ ->
        rest = Enum.drop(state, pos)
        do_run(rest, state, pos)
    end
  end

  # OPCODE 6 - jump if zero
  def do_run([opcode, val, pos | rest], state, count) when rem(opcode, 100) == 6 do
    Logger.debug(inspect({6, opcode, val, pos}))

    modeArg1 = opcode |> div(100) |> rem(10)
    modeArg2 = opcode |> div(1000) |> rem(10)
    pos = get_value(state, modeArg2, pos)

    case get_value(state, modeArg1, val) do
      0 ->
        rest = Enum.drop(state, pos)
        do_run(rest, state, pos)

      _ ->
        do_run(rest, state, count + 3)
    end
  end

  # OPCODE 7 - less than - store 1 or 0
  def do_run([opcode, arg1, arg2, pos | rest], state, count) when rem(opcode, 100) == 7 do
    Logger.debug(inspect({7, opcode, arg1, arg2, pos}))

    count = count + 4
    modeArg1 = opcode |> div(100) |> rem(10)
    modeArg2 = opcode |> div(1000) |> rem(10)

    value =
      if get_value(state, modeArg1, arg1) < get_value(state, modeArg2, arg2),
        do: 1,
        else: 0

    state = List.update_at(state, pos, fn _ -> value end)
    rest = if pos < count, do: rest, else: Enum.drop(state, count)

    do_run(rest, state, count)
  end

  # OPCODE 8 - equals - store 1 or 0
  def do_run([opcode, arg1, arg2, pos | rest], state, count) when rem(opcode, 100) == 8 do
    Logger.debug(inspect({9, opcode, arg1, arg2, pos}))

    count = count + 4
    modeArg1 = opcode |> div(100) |> rem(10)
    modeArg2 = opcode |> div(1000) |> rem(10)

    value =
      if get_value(state, modeArg1, arg1) == get_value(state, modeArg2, arg2),
        do: 1,
        else: 0

    state = List.update_at(state, pos, fn _ -> value end)
    rest = if pos < count, do: rest, else: Enum.drop(state, count)

    do_run(rest, state, count)
  end

  # HALT
  def do_run([opcode | _], state, _pos) when rem(opcode, 100) == 99 do
    Logger.debug(inspect("HALT"))
    state
  end

  defp output(x), do: Logger.debug(inspect(x))

  defp input() do
    IO.write("Input: ")
    IO.read(:line) |> String.trim() |> String.to_integer()
  end

  defp get_value(state, _mode = 0, position), do: Enum.at(state, position)
  defp get_value(_, _mode = 1, value), do: value
end
