{:ok, queries } = PgRandomizer.generator(10, [
  %{table_name: "table", columns: ["a", "b"], types: [:integer, :string]},
  %{table_name: "table2", columns: ["a", "b"], types: [:integer, :string]},
])

Enum.map(queries, fn query -> IO.puts(to_string(query)) end)
