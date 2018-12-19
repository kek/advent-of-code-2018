defmodule Instruction do
  use Bitwise

  def operations do
    %{
      :addr => fn registers, a, b, c ->
        List.replace_at(registers, c, Enum.at(registers, a) + Enum.at(registers, b))
      end,
      :addi => fn registers, a, b, c ->
        List.replace_at(registers, c, Enum.at(registers, a) + b)
      end,
      :mulr => fn registers, a, b, c ->
        List.replace_at(registers, c, Enum.at(registers, a) * Enum.at(registers, b))
      end,
      :muli => fn registers, a, b, c ->
        List.replace_at(registers, c, Enum.at(registers, a) * b)
      end,
      :banr => fn registers, a, b, c ->
        List.replace_at(registers, c, band(Enum.at(registers, a), Enum.at(registers, b)))
      end,
      :bani => fn registers, a, b, c ->
        List.replace_at(registers, c, band(Enum.at(registers, a), b))
      end,
      :borr => fn registers, a, b, c ->
        List.replace_at(registers, c, bor(Enum.at(registers, a), Enum.at(registers, b)))
      end,
      :bori => fn registers, a, b, c ->
        List.replace_at(registers, c, bor(Enum.at(registers, a), b))
      end,
      :setr => fn registers, a, _b, c -> List.replace_at(registers, c, Enum.at(registers, a)) end,
      :seti => fn registers, a, _b, c -> List.replace_at(registers, c, a) end,
      :gtir => fn registers, a, b, c ->
        if a > Enum.at(registers, b) do
          List.replace_at(registers, c, 1)
        else
          List.replace_at(registers, c, 0)
        end
      end,
      :gtri => fn registers, a, b, c ->
        if Enum.at(registers, a) > b do
          List.replace_at(registers, c, 1)
        else
          List.replace_at(registers, c, 0)
        end
      end,
      :gtrr => fn registers, a, b, c ->
        if Enum.at(registers, a) > Enum.at(registers, b) do
          List.replace_at(registers, c, 1)
        else
          List.replace_at(registers, c, 0)
        end
      end,
      :eqir => fn registers, a, b, c ->
        if a == Enum.at(registers, b) do
          List.replace_at(registers, c, 1)
        else
          List.replace_at(registers, c, 0)
        end
      end,
      :eqri => fn registers, a, b, c ->
        if Enum.at(registers, a) == b do
          List.replace_at(registers, c, 1)
        else
          List.replace_at(registers, c, 0)
        end
      end,
      :eqrr => fn registers, a, b, c ->
        if Enum.at(registers, a) == Enum.at(registers, b) do
          List.replace_at(registers, c, 1)
        else
          List.replace_at(registers, c, 0)
        end
      end
    }
  end

  @doc """
  # Addition

  ## addr

  addr (add register) stores into register C the result of adding register A
  and register B.

  ### Examples

      iex> Instruction.perform(:addr, [1, 1, -1, -1], 0, 1, 3)
      [1, 1, -1, 2]

  ## addi

  addi (add immediate) stores into register C the result of adding register A
  and value B.

  ### Examples

      iex> Instruction.perform(:addi, [1, -1, -1, -1], 0, 1, 3)
      [1, -1, -1, 2]

  # Multiplication

  ## mulr

  mulr (multiply register) stores into register C the result of multiplying
  register A and register B.

  ### Examples

      iex> Instruction.perform(:mulr, [3, 3, -1, -1], 0, 1, 3)
      [3, 3, -1, 9]

  ## muli

  muli (multiply immediate) stores into register C the result of multiplying
  register A and value B.

  ### Examples

      iex> Instruction.perform(:muli, [3, 3, -1, -1], 0, 1, 3)
      [3, 3, -1, 3]

  # Bitwise AND

  ## banr

  banr (bitwise AND register) stores into register C the result of the bitwise
  AND of register A and register B.

  ### Examples

      iex> Instruction.perform(:banr, [1, 127, -1, -1], 0, 1, 3)
      [1, 127, -1, 1]

  ## bani

  bani (bitwise AND immediate) stores into register C the result of the bitwise
  AND of register A and value B.

  ### Examples

      iex> Instruction.perform(:bani, [1, 0, -1, -1], 0, 1, 3)
      [1, 0, -1, 1]

  # Bitwise OR:

  ## borr

  borr (bitwise OR register) stores into register C the result of the bitwise
  OR of register A and register B.

  ### Examples

      iex> Instruction.perform(:borr, [0, 0, 0, 0], 0, 1, 3)
      [0, 0, 0, 0]
      iex> Instruction.perform(:borr, [0, 1, 0, 0], 0, 1, 3)
      [0, 1, 0, 1]
      iex> Instruction.perform(:borr, [1, 1, 0, 0], 0, 1, 3)
      [1, 1, 0, 1]

  ## bori

  bori (bitwise OR immediate) stores into register C the result of the bitwise
  OR of register A and value B.

  ### Examples

      iex> Instruction.perform(:bori, [0, 0, 0, 0], 0, 1, 3)
      [0, 0, 0, 1]

  # Assignment

  ## setr

  setr (set register) copies the contents of register A into register C. (Input
  B is ignored.)

  ### Examples

      iex> Instruction.perform(:setr, [1, -1, -1, 0], 0, -1, 3)
      [1, -1, -1, 1]

  ## seti

  seti (set immediate) stores value A into register C. (Input B is ignored.)

  ### Examples

      iex> Instruction.perform(:seti, [1, -1, -1, 0], 2, -1, 3)
      [1, -1, -1, 2]

  ## gtir

  gtir (greater-than immediate/register) sets register C to 1 if value A is
  greater than register B. Otherwise, register C is set to 0.

  ### Examples

      iex> Instruction.perform(:gtir, [0, 0, -1, -1], 0, 1, 3)
      [0, 0, -1, 0]
      iex> Instruction.perform(:gtir, [0, 0, -1, -1], 1, 0, 3)
      [0, 0, -1, 1]
      iex> Instruction.perform(:gtir, [0, 0, -1, -1], 0, 1, 3)
      [0, 0, -1, 0]


  ## gtri

  gtri (greater-than register/immediate) sets register C to 1 if register A is
  greater than value B. Otherwise, register C is set to 0.

  ### Examples

      iex> Instruction.perform(:gtri, [0, 0, 0, -1], 0, 0, 3)
      [0, 0, 0, 0]
      iex> Instruction.perform(:gtri, [0, 0, 0, -1], 0, -1, 3)
      [0, 0, 0, 1]

  ## gtrr

  gtrr (greater-than register/register) sets register C to 1 if register A is
  greater than register B. Otherwise, register C is set to 0.

  ### Examples

      iex> Instruction.perform(:gtrr, [5, 6, 0, -1], 0, 1, 3)
      [5, 6, 0, 0]
      iex> Instruction.perform(:gtrr, [5, 6, 0, -1], 1, 0, 3)
      [5, 6, 0, 1]
      iex> Instruction.perform(:gtrr, [5, 5, 0, -1], 0, 1, 3)
      [5, 5, 0, 0]

  ### Equality testing:

  ## eqir

  eqir (equal immediate/register) sets register C to 1 if value A is equal to
  register B. Otherwise, register C is set to 0.

  ### Examples

      iex> Instruction.perform(:eqir, [0, 0, 0, -1], 0, 0, 3)
      [0, 0, 0, 1]
      iex> Instruction.perform(:eqir, [0, 0, 0, -1], 1, 0, 3)
      [0, 0, 0, 0]

  ## eqri

  eqri (equal register/immediate) sets register C to 1 if register A is equal
  to value B. Otherwise, register C is set to 0.

  ### Examples

      iex> Instruction.perform(:eqri, [5, 0, 0, -1], 0, 5, 3)
      [5, 0, 0, 1]
      iex> Instruction.perform(:eqri, [6, 0, 0, -1], 0, 5, 3)
      [6, 0, 0, 0]

  ## eqrr

  eqrr (equal register/register) sets register C to 1 if register A is equal to
  register B. Otherwise, register C is set to 0.

  ### Examples

      iex> Instruction.perform(:eqrr, [5, 6, 0, -1], 0, 1, 3)
      [5, 6, 0, 0]
      iex> Instruction.perform(:eqrr, [5, 5, 0, -1], 0, 1, 3)
      [5, 5, 0, 1]
  """

  def perform(instruction, registers, a, b, c) do
    operations()[instruction].(registers, a, b, c)
  end
  """
  def perform(:eqrr, registers, a, b, c) do
    if Enum.at(registers, a) == Enum.at(registers, b) do
      List.replace_at(registers, c, 1)
    else
      List.replace_at(registers, c, 0)
    end
  end
end
