defmodule InventoryManagementTest do
  use ExUnit.Case

  import InventoryManagement

  test "checksum" do
    boxes = ["abcdef", "bababc", "abbcde", "abcccd", "aabcdd", "abcdee", "ababab"]

    assert checksum(boxes) == 12
  end

  test "letter_counts" do
    assert letter_counts("abcdef") == %{
             "a" => 1,
             "b" => 1,
             "c" => 1,
             "d" => 1,
             "e" => 1,
             "f" => 1
           }

    assert letter_counts("bababc") == %{"a" => 2, "b" => 3, "c" => 1}
  end

  test "letter_count" do
    assert letter_count("abcdef", "a") == 1
    assert letter_count("bababc", "a") == 2
    assert letter_count("bababc", "d") == 0
  end

  test "has_certain_number_of_letters" do
    assert has_certain_number_of_any_letter("abcdef", 2) == false
    assert has_certain_number_of_any_letter("abcdef", 3) == false
    assert has_certain_number_of_any_letter("bababc", 2) == true
    assert has_certain_number_of_any_letter("bababc", 3) == true
    assert has_certain_number_of_any_letter("abbcde", 2) == true
    assert has_certain_number_of_any_letter("abbcde", 3) == false
    assert has_certain_number_of_any_letter("abcccd", 2) == false
    assert has_certain_number_of_any_letter("abcccd", 3) == true
    assert has_certain_number_of_any_letter("aabcdd", 2) == true
    assert has_certain_number_of_any_letter("aabcdd", 3) == false
    assert has_certain_number_of_any_letter("abcdee", 2) == true
    assert has_certain_number_of_any_letter("abcdee", 3) == false
    assert has_certain_number_of_any_letter("ababab", 2) == false
    assert has_certain_number_of_any_letter("ababab", 3) == true
  end
end
