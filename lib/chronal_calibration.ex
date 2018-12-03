defmodule ChronalCalibration do
  def apply_changes(changes) do
    Enum.sum(changes)
  end

  def first_reached_twice(changes) do
    me = self()

    spawn_link(fn ->
      Stream.cycle(changes)
      |> Stream.scan({0, MapSet.new()}, fn change, {frequency, seen} ->
        frequency = frequency + change
        if MapSet.member?(seen, frequency), do: send(me, frequency)
        {frequency, MapSet.put(seen, frequency)}
      end)
      |> Stream.run()
    end)

    receive do
      result -> result
    after
      1000 -> :timeout
    end
  end
end
