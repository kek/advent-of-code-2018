defmodule ChronalCalibrationTest do
  use ExUnit.Case

  import ChronalCalibration

  test "summing the changes" do
    changes = [+1, -2, +3, +1]

    assert apply_changes(changes) == 3
  end

  test "determining which frequency is first found twice" do
    changes = [+1, -2, +3, +1]

    assert first_reached_twice(changes) == 2
  end
end
