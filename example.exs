{:ok, queries } = PgRandomizer.generate(10, [
  %{table_name: "films", columns: ["code", "title"], types: [:integer, :string]},
  %{table_name: "distributors", columns: ["did", "name"], types: [:integer, :string]},
])

Enum.map(queries, fn query -> IO.puts(to_string(query)) end)

{:ok, pid} = Postgrex.start_link(hostname: "localhost", username: "postgres", password: "postgres", database: "postgres")

Enum.map(queries, fn query ->
  {:ok, res} = Postgrex.query(pid, query)
  IO.inspect(res)
end)
