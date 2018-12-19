defmodule Opcodes do
  use Bitwise

  # Addition:

  @doc """
  addr (add register) stores into register C the result of adding
  register A and register B.

  ## Examples

      iex> Opcodes.addr([1, 1, -1, -1], 0, 1, 3)
      [1, 1, -1, 2]
  """
  def addr(registers, a, b, c) do
    List.replace_at(registers, c, Enum.at(registers, a) + Enum.at(registers, b))
  end

  @doc """
  addi (add immediate) stores into register C the result of adding
  register A and value B.

  ## Examples

      iex> Opcodes.addi([1, -1, -1, -1], 0, 1, 3)
      [1, -1, -1, 2]
  """
  def addi(registers, a, b, c) do
    List.replace_at(registers, c, Enum.at(registers, a) + b)
  end

  # Multiplication:

  @doc """
  mulr (multiply register) stores into register C the result of
  multiplying register A and register B.

  ## Examples

      iex> Opcodes.mulr([3, 3, -1, -1], 0, 1, 3)
      [3, 3, -1, 9]
  """
  def mulr(registers, a, b, c) do
    List.replace_at(registers, c, Enum.at(registers, a) * Enum.at(registers, b))
  end

  @doc """
  muli (multiply immediate) stores into register C the result of
  multiplying register A and value B.

  ## Examples

      iex> Opcodes.muli([3, 3, -1, -1], 0, 1, 3)
      [3, 3, -1, 3]
  """
  def muli(registers, a, b, c) do
    List.replace_at(registers, c, Enum.at(registers, a) * b)
  end

  # Bitwise AND:
  @doc """
  banr (bitwise AND register) stores into register C the result of
  the bitwise AND of register A and register B.

  ## Examples

      iex> Opcodes.banr([1, 127, -1, -1], 0, 1, 3)
      [1, 127, -1, 1]
  """
  def banr(registers, a, b, c) do
    List.replace_at(registers, c, band(Enum.at(registers, a), Enum.at(registers, b)))
  end

  @doc """
  bani (bitwise AND immediate) stores into register C the result
  of the bitwise AND of register A and value B.

  ## Examples

      iex> Opcodes.bani([1, 0, -1, -1], 0, 1, 3)
      [1, 0, -1, 1]
  """
  def bani(registers, a, b, c) do
    List.replace_at(registers, c, band(Enum.at(registers, a), b))
  end

  ### Bitwise OR:

  @doc """
  borr (bitwise OR register) stores into register C the result of
  the bitwise OR of register A and register B.

  ## Examples

      iex> Opcodes.borr([0, 0, 0, 0], 0, 1, 3)
      [0, 0, 0, 0]
      iex> Opcodes.borr([0, 1, 0, 0], 0, 1, 3)
      [0, 1, 0, 1]
      iex> Opcodes.borr([1, 1, 0, 0], 0, 1, 3)
      [1, 1, 0, 1]
  """
  def borr(registers, a, b, c) do
    List.replace_at(registers, c, bor(Enum.at(registers, a), Enum.at(registers, b)))
  end

  @doc """
  bori (bitwise OR immediate) stores into register C the result of
  the bitwise OR of register A and value B.

  ## Examples

      iex> Opcodes.bori([0, 0, 0, 0], 0, 1, 3)
      [0, 0, 0, 1]
  """
  def bori(registers, a, b, c) do
    List.replace_at(registers, c, bor(Enum.at(registers, a), b))
  end

  ### Assignment:

  @doc """
  setr (set register) copies the contents of register A into
  register C. (Input B is ignored.)

  ## Examples

      iex> Opcodes.setr([1, -1, -1, 0], 0, -1, 3)
      [1, -1, -1, 1]
  """
  def setr(registers, a, _b, c) do
    List.replace_at(registers, c, Enum.at(registers, a))
  end

  @doc """
  seti (set immediate) stores value A into register C. (Input B is
  ignored.)

  ## Examples

      iex> Opcodes.seti([1, -1, -1, 0], 2, -1, 3)
      [1, -1, -1, 2]
  """
  def seti(registers, a, _b, c) do
    List.replace_at(registers, c, a)
  end

  ### Greater-than testing:

  @doc """
  gtir (greater-than immediate/register) sets register C to 1 if value A is
  greater than register B. Otherwise, register C is set to 0.

  ## Examples

      iex> Opcodes.gtir([0, 0, -1, -1], 0, 1, 3)
      [0, 0, -1, 0]
      iex> Opcodes.gtir([0, 0, -1, -1], 1, 0, 3)
      [0, 0, -1, 1]
      iex> Opcodes.gtir([0, 0, -1, -1], 0, 1, 3)
      [0, 0, -1, 0]
  """
  def gtir(registers, a, b, c) do
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

      iex> Opcodes.gtri([0, 0, 0, -1], 0, 0, 3)
      [0, 0, 0, 0]
      iex> Opcodes.gtri([0, 0, 0, -1], 0, -1, 3)
      [0, 0, 0, 1]
  """
  def gtri(registers, a, b, c) do
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

      iex> Opcodes.gtrr([5, 6, 0, -1], 0, 1, 3)
      [5, 6, 0, 0]
      iex> Opcodes.gtrr([5, 6, 0, -1], 1, 0, 3)
      [5, 6, 0, 1]
      iex> Opcodes.gtrr([5, 5, 0, -1], 0, 1, 3)
      [5, 5, 0, 0]
  """
  def gtrr(registers, a, b, c) do
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

      iex> Opcodes.eqir([0, 0, 0, -1], 0, 0, 3)
      [0, 0, 0, 1]
      iex> Opcodes.eqir([0, 0, 0, -1], 1, 0, 3)
      [0, 0, 0, 0]
  """
  def eqir(registers, a, b, c) do
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

      iex> Opcodes.eqri([5, 0, 0, -1], 0, 5, 3)
      [5, 0, 0, 1]
      iex> Opcodes.eqri([6, 0, 0, -1], 0, 5, 3)
      [6, 0, 0, 0]
  """
  def eqri(registers, a, b, c) do
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

      iex> Opcodes.eqrr([5, 6, 0, -1], 0, 1, 3)
      [5, 6, 0, 0]
      iex> Opcodes.eqrr([5, 5, 0, -1], 0, 1, 3)
      [5, 5, 0, 1]

  """
  def eqrr(registers, a, b, c) do
    if Enum.at(registers, a) == Enum.at(registers, b) do
      List.replace_at(registers, c, 1)
    else
      List.replace_at(registers, c, 0)
    end
  end
end
