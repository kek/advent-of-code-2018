defmodule Instruction do
  use Bitwise

  # Addition:

  @doc """
  addr (add register) stores into register C the result of adding
  register A and register B.

  ## Examples

      iex> Instruction.perform(:addr, [1, 1, -1, -1], 0, 1, 3)
      [1, 1, -1, 2]
  """
  def perform(:addr, registers, a, b, c) do
    List.replace_at(registers, c, Enum.at(registers, a) + Enum.at(registers, b))
  end

  @doc """
  addi (add immediate) stores into register C the result of adding
  register A and value B.

  ## Examples

      iex> Instruction.perform(:addi, [1, -1, -1, -1], 0, 1, 3)
      [1, -1, -1, 2]
  """
  def perform(:addi, registers, a, b, c) do
    List.replace_at(registers, c, Enum.at(registers, a) + b)
  end

  # Multiplication:

  @doc """
  mulr (multiply register) stores into register C the result of
  multiplying register A and register B.

  ## Examples

      iex> Instruction.perform(:mulr, [3, 3, -1, -1], 0, 1, 3)
      [3, 3, -1, 9]
  """
  def perform(:mulr, registers, a, b, c) do
    List.replace_at(registers, c, Enum.at(registers, a) * Enum.at(registers, b))
  end

  @doc """
  muli (multiply immediate) stores into register C the result of
  multiplying register A and value B.

  ## Examples

      iex> Instruction.perform(:muli, [3, 3, -1, -1], 0, 1, 3)
      [3, 3, -1, 3]
  """
  def perform(:muli, registers, a, b, c) do
    List.replace_at(registers, c, Enum.at(registers, a) * b)
  end

  # Bitwise AND:
  @doc """
  banr (bitwise AND register) stores into register C the result of
  the bitwise AND of register A and register B.

  ## Examples

      iex> Instruction.perform(:banr, [1, 127, -1, -1], 0, 1, 3)
      [1, 127, -1, 1]
  """
  def perform(:banr, registers, a, b, c) do
    List.replace_at(registers, c, band(Enum.at(registers, a), Enum.at(registers, b)))
  end

  @doc """
  bani (bitwise AND immediate) stores into register C the result
  of the bitwise AND of register A and value B.

  ## Examples

      iex> Instruction.perform(:bani, [1, 0, -1, -1], 0, 1, 3)
      [1, 0, -1, 1]
  """
  def perform(:bani, registers, a, b, c) do
    List.replace_at(registers, c, band(Enum.at(registers, a), b))
  end

  ### Bitwise OR:

  @doc """
  borr (bitwise OR register) stores into register C the result of
  the bitwise OR of register A and register B.

  ## Examples

      iex> Instruction.perform(:borr, [0, 0, 0, 0], 0, 1, 3)
      [0, 0, 0, 0]
      iex> Instruction.perform(:borr, [0, 1, 0, 0], 0, 1, 3)
      [0, 1, 0, 1]
      iex> Instruction.perform(:borr, [1, 1, 0, 0], 0, 1, 3)
      [1, 1, 0, 1]
  """
  def perform(:borr, registers, a, b, c) do
    List.replace_at(registers, c, bor(Enum.at(registers, a), Enum.at(registers, b)))
  end

  @doc """
  bori (bitwise OR immediate) stores into register C the result of
  the bitwise OR of register A and value B.

  ## Examples

      iex> Instruction.perform(:bori, [0, 0, 0, 0], 0, 1, 3)
      [0, 0, 0, 1]
  """
  def perform(:bori, registers, a, b, c) do
    List.replace_at(registers, c, bor(Enum.at(registers, a), b))
  end

  ### Assignment:

  @doc """
  setr (set register) copies the contents of register A into
  register C. (Input B is ignored.)

  ## Examples

      iex> Instruction.perform(:setr, [1, -1, -1, 0], 0, -1, 3)
      [1, -1, -1, 1]
  """
  def perform(:setr, registers, a, _b, c) do
    List.replace_at(registers, c, Enum.at(registers, a))
  end

  @doc """
  seti (set immediate) stores value A into register C. (Input B is
  ignored.)

  ## Examples

      iex> Instruction.perform(:seti, [1, -1, -1, 0], 2, -1, 3)
      [1, -1, -1, 2]
  """
  def perform(:seti, registers, a, _b, c) do
    List.replace_at(registers, c, a)
  end

  ### Greater-than testing:

  @doc """
  gtir (greater-than immediate/register) sets register C to 1 if value A is
  greater than register B. Otherwise, register C is set to 0.

  ## Examples

      iex> Instruction.perform(:gtir, [0, 0, -1, -1], 0, 1, 3)
      [0, 0, -1, 0]
      iex> Instruction.perform(:gtir, [0, 0, -1, -1], 1, 0, 3)
      [0, 0, -1, 1]
      iex> Instruction.perform(:gtir, [0, 0, -1, -1], 0, 1, 3)
      [0, 0, -1, 0]
  """
  def perform(:gtir, registers, a, b, c) do
    if a > Enum.at(registers, b) do
      List.replace_at(registers, c, 1)
    else
      List.replace_at(registers, c, 0)
    end
  end

  @doc """
  gtri (greater-than register/immediate) sets register C to 1 if register A is
  greater than value B. Otherwise, register C is set to 0.

  ## Examples

      iex> Instruction.perform(:gtri, [0, 0, 0, -1], 0, 0, 3)
      [0, 0, 0, 0]
      iex> Instruction.perform(:gtri, [0, 0, 0, -1], 0, -1, 3)
      [0, 0, 0, 1]
  """
  def perform(:gtri, registers, a, b, c) do
    if Enum.at(registers, a) > b do
      List.replace_at(registers, c, 1)
    else
      List.replace_at(registers, c, 0)
    end
  end

  @doc """
  gtrr (greater-than register/register) sets register C to 1 if register A is
  greater than register B. Otherwise, register C is set to 0.

  ## Examples

      iex> Instruction.perform(:gtrr, [5, 6, 0, -1], 0, 1, 3)
      [5, 6, 0, 0]
      iex> Instruction.perform(:gtrr, [5, 6, 0, -1], 1, 0, 3)
      [5, 6, 0, 1]
      iex> Instruction.perform(:gtrr, [5, 5, 0, -1], 0, 1, 3)
      [5, 5, 0, 0]
  """
  def perform(:gtrr, registers, a, b, c) do
    if Enum.at(registers, a) > Enum.at(registers, b) do
      List.replace_at(registers, c, 1)
    else
      List.replace_at(registers, c, 0)
    end
  end

  ### Equality testing:
  #
  @doc """
  eqir (equal immediate/register) sets register C to 1 if value A is equal to
  register B. Otherwise, register C is set to 0.

  ## Examples

      iex> Instruction.perform(:eqir, [0, 0, 0, -1], 0, 0, 3)
      [0, 0, 0, 1]
      iex> Instruction.perform(:eqir, [0, 0, 0, -1], 1, 0, 3)
      [0, 0, 0, 0]
  """
  def perform(:eqir, registers, a, b, c) do
    if a == Enum.at(registers, b) do
      List.replace_at(registers, c, 1)
    else
      List.replace_at(registers, c, 0)
    end
  end

  @doc """
  eqri (equal register/immediate) sets register C to 1 if register A is equal
  to value B. Otherwise, register C is set to 0.

  ## Examples

      iex> Instruction.perform(:eqri, [5, 0, 0, -1], 0, 5, 3)
      [5, 0, 0, 1]
      iex> Instruction.perform(:eqri, [6, 0, 0, -1], 0, 5, 3)
      [6, 0, 0, 0]
  """
  def perform(:eqri, registers, a, b, c) do
    if Enum.at(registers, a) == b do
      List.replace_at(registers, c, 1)
    else
      List.replace_at(registers, c, 0)
    end
  end

  @doc """
  eqrr (equal register/register) sets register C to 1 if register A is equal to
  register B. Otherwise, register C is set to 0.

  ## Examples

      iex> Instruction.perform(:eqrr, [5, 6, 0, -1], 0, 1, 3)
      [5, 6, 0, 0]
      iex> Instruction.perform(:eqrr, [5, 5, 0, -1], 0, 1, 3)
      [5, 5, 0, 1]

  """
  def perform(:eqrr, registers, a, b, c) do
    if Enum.at(registers, a) == Enum.at(registers, b) do
      List.replace_at(registers, c, 1)
    else
      List.replace_at(registers, c, 0)
    end
  end
end
