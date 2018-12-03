defmodule Day1Test do
  use ExUnit.Case

  import ChronalCalibration

  test "summing the changes" do
    changes = [+1, -2, +3, +1]

    assert apply_changes(changes) == 3
  end

  test "solution 1" do
    assert AdventOfCode2018.Day1.solution1() == 479
  end
end
