defmodule AdventOfCode2018.Day2 do
  def solution1 do
    read_input()
    |> InventoryManagement.checksum()
  end

  def solution2 do
    read_input()
    |> InventoryManagement.common_characters_between_strings_differing_by_1()
  end

  defp read_input do
    File.read!("priv/inputs/2.txt")
    |> String.split("\n", trim: true)
  end
end
