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

        if MapSet.member?(seen, frequency) do
          # IO.puts("found #{frequency} in #{inspect(seen)}")
          send(me, frequency)
          seen
        end

        # IO.inspect(
        #   "The change is #{change}. New frequency is #{frequency}. Seen #{inspect(seen)}"
        # )

        seen = MapSet.put(seen, frequency)

        {frequency, seen}
      end)
      |> Stream.run()
    end)

    receive do
      x ->
        x
    after
      1000 ->
        :timeout
    end
  end
end
