defmodule AdventOfCode2018.Day1 do
  def solution1 do
    File.read!("priv/inputs/1.txt")
    |> String.split("\n", trim: true)
    |> Enum.map(&String.to_integer/1)
    |> ChronalCalibration.apply_changes()
  end
end
