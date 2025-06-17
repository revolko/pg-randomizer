defmodule PgRandomizerTest do
  use ExUnit.Case
  doctest PgRandomizer

  test "generate" do
    table_opts = [
      %{table_name: "films", columns: ["code", "title"], types: [:integer, :string]},
      %{table_name: "distributors", columns: ["did", "name"], types: [:integer, :string]},
    ]
    {res, queries} = PgRandomizer.generate(10, table_opts)
    assert res == :ok
    assert is_list(queries)
  end
end
