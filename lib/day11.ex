defmodule AdventOfCode2018.Day11 do
  def solution1 do
    ChronalCharge.largest_total_power(5177, 3)
  end

  def solution2 do
    ChronalCharge.largest_total_power_for_any_size(5177)
  end
end
