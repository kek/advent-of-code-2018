defmodule ChronalChargeTest do
  use ExUnit.Case

  doctest ChronalCharge

  setup_all do
    {:ok, _} = :eprof.start()
    # :eprof.start_profiling([self()])

    on_exit(fn ->
      # :eprof.stop_profiling()
      # :eprof.analyze(:total)
      :ok
    end)
  end
end
