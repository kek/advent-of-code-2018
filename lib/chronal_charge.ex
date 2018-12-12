defmodule ChronalCharge do
  @doc """
  Finds the rack ID of a cell.

  ## Examples

      iex> ChronalCharge.rack_id({3,5})
      13
  """
  def rack_id({x, _}), do: x + 10

  @doc """
  Determines the power level of a cell.

  ## Examples

      iex> ChronalCharge.power_level({3,5}, 8)
      4
      iex> ChronalCharge.power_level({  122,79}, 57)
      -5
      iex> ChronalCharge.power_level({ 217,196}, 39)
      0
      iex> ChronalCharge.power_level({ 101,153}, 71)
      4
  """
  def power_level({x, y}, grid_serial_number) do
    rack_id = x + 10
    power_level = rack_id * y
    power_level = power_level + grid_serial_number
    power_level = power_level * rack_id
    digits = power_level |> Integer.to_string() |> String.codepoints()

    hundreds =
      case Enum.slice(digits, -3..-3) do
        [] -> 0
        [x] -> String.to_integer(x)
      end

    hundreds - 5
  end

  @doc """
  Determines the total power of a 3*3 square.

  Examples

      iex> ChronalCharge.total_power({33,45}, 18, 3)
      29
      iex> ChronalCharge.total_power({21,61}, 42, 3)
      30

  """
  def total_power({x, y}, grid_serial_number, square_size) do
    for x1 <- x..(x + square_size - 1), y1 <- y..(y + square_size - 1) do
      power_level({x1, y1}, grid_serial_number)
    end
    |> Enum.sum()
  end

  @doc """
  Determines the x,y coordinate of the top-left fuel cell in the 3*3 square
  with the largest total power.

  ## Examples

      iex> ChronalCharge.largest_total_power(18, 3)
      {{33,45}, 29}
      iex> ChronalCharge.largest_total_power(42, 3)
      {{21,61}, 30}
  """
  def largest_total_power(grid_serial_number, square_size) do
    for x <- 1..(300 - square_size + 1), y <- 1..(300 - square_size + 1) do
      {{x, y}, total_power({x, y}, grid_serial_number, square_size)}
    end
    |> Enum.sort(fn {_, a}, {_, b} -> a > b end)
    |> hd()
  end

  @doc """
  Finds the largest total power for a square of any size.

  ## Examples

      iex> ChronalCharge.largest_total_power_for_any_size(18)
      {{90,269}, 16}
      iex> ChronalCharge.largest_total_power_for_any_size(42)
      {{232,251}, 12}
  """
  def largest_total_power_for_any_size(grid_serial_number) do
    1..300
    |> Enum.each(fn size ->
      {largest_total_power(grid_serial_number, size), size}
    end)
    |> Enum.sort(fn {{{x, y}, power1}, size}, {{{x, y}, power2}, size} -> power1 > power2 end)
    |> hd()
  end
end
