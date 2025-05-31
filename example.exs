table_opts = [
  %{table_name: "films", columns: ["code", "title"], types: [:integer, :string]},
  %{table_name: "distributors", columns: ["did", "name"], types: [:integer, :string]},
]
{:ok, queries } = PgRandomizer.generate(10, table_opts)

Enum.map(queries, fn query -> IO.puts(to_string(query)) end)

:ok = PgRandomizer.generate_with_connection(
  10,
  table_opts,
  %{hostname: "localhost", username: "postgres", password: "postgres", database: "postgres"}
)
