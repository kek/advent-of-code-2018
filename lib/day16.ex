defmodule AdventOfCode2018.Day16 do
  def solution1 do
    File.read!("priv/inputs/16a.txt")
    |> String.split("\n", trim: true)
    |> Enum.chunk_every(3)
    |> Enum.map(&parse/1)
    |> Enum.filter(fn {before_state, [_opcode, a, b, c], after_state} ->
      Enum.count(Instruction.possible_instructions(before_state, after_state, a, b, c)) >= 3
    end)
    |> Enum.count()
  end

  defp parse([before_string, codes_string, after_string]) do
    before_state =
      ~r/Before: \[(\d+), (\d+), (\d+), (\d+)\]/
      |> Regex.scan(before_string)
      |> Enum.at(0)
      |> Enum.drop(1)
      |> Enum.map(&String.to_integer/1)

    after_state =
      ~r/After: +\[(\d+), (\d+), (\d+), (\d+)\]/
      |> Regex.scan(after_string)
      |> Enum.at(0)
      |> Enum.drop(1)
      |> Enum.map(&String.to_integer/1)

    codes = codes_string |> String.split(" ") |> Enum.map(&String.to_integer/1)

    {before_state, codes, after_state}
  end

  def solution2 do
    1
  end
end
