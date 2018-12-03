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

  test "determining which frequency is first found twice" do
    changes = [+1, -2, +3, +1]

    assert first_reached_twice(changes) == 2
  end

  test "solution 2" do
    assert AdventOfCode2018.Day1.solution2() == 66105
  end
end
