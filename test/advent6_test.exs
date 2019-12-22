defmodule Advent6.Test do
  use ExUnit.Case
  doctest AdventOfCode2019

  test "1 <- 2" do
    assert Advent6.run("1)2") == 1
  end

  test "1 <- 2 <- 3" do
    assert Advent6.run("1)2\n2)3") == 3
  end

  test "1 <- 2 <- 3 <- 4" do
    assert Advent6.run("1)2\n2)3\n3)4") == 6
  end

  test "one branch - 1" do
    assert Advent6.run("1)2\n1)3") == 2
  end

  test "one branch - 2" do
    assert Advent6.run("1)2\n2)3\n2)4") == 5
  end

  test "four branches - 1" do
    assert Advent6.run("COM)B\n B)C\n C)D\n D)E\n E)F\n B)G\n G)H\n D)I\n E)J\n J)K\n K)L\n") ==
             42
  end

  test "task input" do
    assert Advent6.run(Advent6.Data.get()) == 621_125
  end
end
