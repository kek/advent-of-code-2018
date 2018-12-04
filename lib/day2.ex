defmodule AdventOfCode2018.Day2 do
  def solution1 do
    read_input()
    |> InventoryManagement.checksum()
  end

  defp read_input do
    File.read!("priv/inputs/2.txt")
    |> String.split("\n", trim: true)
  end
end
