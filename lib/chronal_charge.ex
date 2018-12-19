defmodule ChronalCharge do
  # https://en.wikipedia.org/wiki/Summed-area_table
  require Logger

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
    {:power_level, x, y, grid_serial_number}
    |> memoize(fn ->
      rack_id = x + 10
      power_level = rack_id * y
      power_level = power_level + grid_serial_number
      power_level = power_level * rack_id

      hundreds = digits(power_level)

      hundreds - 5
    end)
  end

  def digits(n), do: n |> div(100) |> rem(10)

  @doc """
  Determines the total power of a z*z square.

  ## Examples

      iex> ChronalCharge.total_power({33,45}, 18, 3)
      29
      iex> ChronalCharge.total_power({21,61}, 42, 3)
      30
  """
  def total_power({x, y}, grid_serial_number, square_size) do
    {:total_power, x, y, grid_serial_number, square_size}
    |> memoize(fn ->
      # xrange = x..(x + square_size - 1)
      # yrange = y..(y + square_size - 1)
      xrange = memoize({:range, x, square_size}, fn -> x..(x + square_size - 1) end)
      yrange = memoize({:range, y, square_size}, fn -> y..(y + square_size - 1) end)

      for x1 <- xrange, y1 <- yrange do
        {:power_level, x1, y1, grid_serial_number}
        |> memoize(fn ->
          power_level({x1, y1}, grid_serial_number)
        end)
      end
      |> Enum.sum()
    end)
  end

  @doc """
  Determines the x,y coordinate of the top-left fuel cell in the z*z square
  with the largest total power.

  ## Examples

      iex> ChronalCharge.largest_total_power(18, 3)
      {{33,45}, 29}
      iex> ChronalCharge.largest_total_power(42, 3)
      {{21,61}, 30}
  """
  def largest_total_power(grid_serial_number, square_size) do
    {:largest_total_power, grid_serial_number, square_size}
    |> memoize(fn ->
      xrange = memoize({:range, square_size}, fn -> 1..(300 - square_size + 1) end)
      yrange = memoize({:range, square_size}, fn -> 1..(300 - square_size + 1) end)

      for x <- xrange, y <- yrange do
        {{x, y}, total_power({x, y}, grid_serial_number, square_size)}
      end
      |> Enum.max_by(fn {_, a} -> a end)
    end)
  end

  # @doc """
  # Finds the largest total power for a square of any size.

  # ## Examples

  #     iex> ChronalCharge.largest_total_power_for_any_size(18)
  #     {{90,269}, 16}
  #     iex> ChronalCharge.largest_total_power_for_any_size(42)
  #     {{232,251}, 12}
  # """
  def largest_total_power_for_any_size(grid_serial_number, max_size \\ 300) do
    1..max_size
    |> Enum.map(fn size ->
      # Task.async(fn ->
      Logger.info("calculating largest_total_power for #{size}")

      {time, result} = :timer.tc(fn -> {largest_total_power(grid_serial_number, size), size} end)

      Logger.info("time: #{time}, result: #{inspect(result)}")
      result
      # end)
    end)
    # |> Enum.map(&Task.await(&1, 10_000_000))
    |> Enum.max_by(fn a = {{{_x, _y}, power}, _size} ->
      Logger.info("calculating max for #{inspect(a)}")
      power
    end)
  end

  # defp memoize(key, fun) do
  #   case Process.get(key) do
  #     nil ->
  #       value = fun.()
  #       Logger.info("Putting #{inspect(key)} => #{inspect(value)}")
  #       Process.put(key, value)
  #       value

  #     x ->
  #       x
  #   end
  # end

  defp memoize(key, fun) do
    case :ets.lookup(:elixir_config, key) do
      [{^key, value}] ->
        value

      [] ->
        value = fun.()
        # Logger.info("Putting #{inspect(key)} => #{inspect(value)}")
        true = :ets.insert(:elixir_config, {key, value})
        value
    end
  end
end
