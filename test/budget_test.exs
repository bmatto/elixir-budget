defmodule BudgetTest do
  use ExUnit.Case, async: true
  doctest Budget

  test "reads csv into list" do
    contents = Budget.getFileContents("./bank.csv")
    assert is_list(contents) == true
  end

  test "groups by category" do
    contents = [
      {:ok, ["posted", "", "02/15/2018", "", "movies", "fun", "-10"]},
      {:ok, ["posted", "", "02/15/2018", "", "pizza", "food", "-60"]},
      {:ok, ["posted", "", "02/15/2018", "", "burgers", "food", "-80"]}
    ]

    IO.inspect Budget.groupByCategory(contents)["food"]

    assert length(Budget.groupByCategory(contents)["food"]) == 2
    assert length(Budget.groupByCategory(contents)["fun"]) == 1
  end

  test "sums category" do
    category =[
      ok: ["posted", "", "02/15/2018", "", "pizza", "food", "-60"],
      ok: ["posted", "", "02/15/2018", "", "burgers", "food", "-80"]
    ]

    assert Budget.sumCategory({"food", category}) == {:ok, "food", -140.0}
  end
end
