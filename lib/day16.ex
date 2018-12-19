defmodule AdventOfCode2018.Day16 do
  def solution1 do
    samples()
    |> Enum.filter(fn {before_state, [_opcode, a, b, c], after_state} ->
      Enum.count(Instruction.possible_instructions(before_state, after_state, a, b, c)) >= 3
    end)
    |> Enum.count()
  end

  defp samples() do
    File.read!("priv/inputs/16a.txt")
    |> String.split("\n", trim: true)
    |> Enum.chunk_every(3)
    |> Enum.map(&parse/1)
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
    # run_program(program(), opcodes())
    opcodes()
  end

  defp opcodes() do
    samples()
    |> calculate_opcodes_pass1()
    |> IO.inspect(label: "pass 1")
    |> calculate_opcodes_pass2()
    |> calculate_opcodes_pass2()
    |> calculate_opcodes_pass2()
    |> calculate_opcodes_pass2()
    |> calculate_opcodes_pass2()
    |> calculate_opcodes_pass2()
    |> calculate_opcodes_pass2()
    |> calculate_opcodes_pass2()
    |> calculate_opcodes_pass2()
    |> calculate_opcodes_pass2()
    |> calculate_opcodes_pass2()
    |> calculate_opcodes_pass2()
    |> calculate_opcodes_pass2()
    |> Enum.map(fn {key, set} -> {key, MapSet.to_list(set) |> Enum.at(0)} end)
    |> Map.new()
  end

  defp calculate_opcodes_pass1(samples), do: calculate_opcodes_pass1(samples, %{})
  defp calculate_opcodes_pass1([], opcodes), do: opcodes

  defp calculate_opcodes_pass1([{before_state, [opcode, a, b, c], after_state} | rest], opcodes) do
    case Instruction.possible_instructions(before_state, after_state, a, b, c) do
      [] ->
        calculate_opcodes_pass1(rest, opcodes)

      instructions ->
        old_instructions = Map.get(opcodes, opcode, MapSet.new())

        new_instructions =
          Enum.reduce(instructions, old_instructions, fn instruction, acc ->
            MapSet.put(acc, instruction)
          end)

        opcodes = Map.put(opcodes, opcode, new_instructions)
        calculate_opcodes_pass1(rest, opcodes)
    end
  end

  defp calculate_opcodes_pass2(opcodes) do
    sure_codes =
      opcodes
      |> Enum.filter(fn {_key, possible_instructions} ->
        MapSet.size(possible_instructions) == 1
      end)
      |> Map.new()
      |> IO.inspect(label: "sure codes")

    sure_instructions =
      sure_codes
      |> Enum.flat_map(fn {_, set} -> MapSet.to_list(set) end)
      |> Enum.uniq()
      |> IO.inspect(label: "Sure instructions")

    unsure_codes =
      opcodes
      |> Enum.reject(fn {_, set} ->
        list = MapSet.to_list(set)

        Enum.all?(list, fn instruction ->
          Enum.member?(sure_instructions, instruction)
        end)
      end)
      |> IO.inspect(label: "still unsure codes")

    filtered_codes =
      unsure_codes
      |> Enum.map(fn {opcode, set} ->
        new_set =
          Enum.reduce(sure_instructions, set, fn instruction, acc ->
            MapSet.delete(acc, instruction)
          end)

        {opcode, new_set}
      end)
      |> Map.new()
      |> IO.inspect(label: "filtered codes")

    Map.merge(filtered_codes, sure_codes)
  end
end
