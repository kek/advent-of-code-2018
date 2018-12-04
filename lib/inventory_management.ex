defmodule InventoryManagement do
  def checksum(boxes) do
    twos =
      boxes
      |> Enum.filter(&has_certain_number_of_any_letter(&1, 2))
      |> Enum.count()

    threes =
      boxes
      |> Enum.filter(&has_certain_number_of_any_letter(&1, 3))
      |> Enum.count()

    twos * threes
  end

  def letter_counts(box) do
    letter_counts(box, %{})
  end

  defp letter_counts("", counts), do: counts

  defp letter_counts(box, counts) do
    letter = String.first(box)
    counts = counts |> Map.update(letter, 1, &(&1 + 1))

    box
    |> String.slice(1..-1)
    |> letter_counts(counts)
  end

  def letter_count(box, letter) do
    box
    |> letter_counts
    |> Map.get(letter, 0)
  end

  def has_certain_number_of_any_letter(box, number) do
    box
    |> letter_counts
    |> Map.values()
    |> Enum.any?(&(&1 == number))
  end
end
