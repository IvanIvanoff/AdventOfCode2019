defmodule Advent6 do
  def run(input \\ Advent6.Data.get()) do
    {tree, planets, moons} =
      input
      |> parse_input()
      |> build_tree()

    [root] = Enum.filter(planets, fn p -> not (p in moons) end)

    do_count_orbits(root, tree, 0, 0)
  end

  defp do_count_orbits(root, tree, path, orbits) do
    case Map.get(tree, root, []) do
      [] ->
        orbits + path

      [moon] ->
        do_count_orbits(moon, tree, path + 1, orbits + path)

      moons ->
        orbits + path +
          (Enum.map(moons, &do_count_orbits(&1, tree, path + 1, 0))
           |> Enum.sum())
    end
  end

  defp build_tree(data) do
    Enum.reduce(
      data,
      {%{}, MapSet.new(), MapSet.new()},
      fn {planet, moon}, {tree, is_planet, is_moon} ->
        tree = Map.update(tree, planet, [moon], fn list -> [moon | list] end)
        {tree, MapSet.put(is_planet, planet), MapSet.put(is_moon, moon)}
      end
    )
  end

  defp parse_input(data) do
    String.split(data, "\n", trim: true)
    |> Enum.map(fn row ->
      [planet, moon] = String.split(row, ")", trim: true) |> Enum.map(&String.trim/1)
      {planet, moon}
    end)
  end
end
