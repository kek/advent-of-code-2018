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

  @doc ~S"""
  Calculates the Levenshtein distance between two strings.

  ## Examples

      iex> InventoryManagement.levenshtein_distance("a", "a")
      0

      iex> InventoryManagement.levenshtein_distance("a", "b")
      1

      iex> InventoryManagement.levenshtein_distance("abcde", "axcye")
      2

      iex> InventoryManagement.levenshtein_distance("fghij", "fguij")
      1
  """
  def levenshtein_distance(a, b) when is_binary(a) and is_binary(b) do
    levenshtein_distance(String.codepoints(a), String.codepoints(b))
  end

  def levenshtein_distance([same | left_tail], [same | right_tail]),
    do: 0 + levenshtein_distance(left_tail, right_tail)

  def levenshtein_distance([_ | left_tail], [_ | right_tail]),
    do: 1 + levenshtein_distance(left_tail, right_tail)

  def levenshtein_distance([], []), do: 0
end
