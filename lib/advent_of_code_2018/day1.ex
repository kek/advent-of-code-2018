defmodule AdventOfCode2018.Day1 do
  def solution1 do
    read_input()
    |> ChronalCalibration.apply_changes()
  end

  def solution2 do
    read_input()
    |> ChronalCalibration.first_reached_twice()
  end

  defp read_input do
    File.read!("priv/inputs/1.txt")
    |> String.split("\n", trim: true)
    |> Enum.map(&String.to_integer/1)
  end
end
