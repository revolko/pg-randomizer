defmodule PgRandomizer do
  @moduledoc """
  Documentation for `PgRandomizer`.
  """

  def generate_with_connection(n, table_opts, db_opts) do
    {:ok, queries } = PgRandomizer.generate(n, table_opts)

    {:ok, pid} = Postgrex.start_link(
      hostname: db_opts.hostname,
      username: db_opts.username,
      password: db_opts.password,
      database: db_opts.database
    )

    Enum.map(queries, fn query ->
      {:ok, _} = Postgrex.query(pid, query)
    end)
    :ok
  end

  @doc """
  Generator of (for now only insert) SQL queries.
  Expects number of queries to generate and
  table specification (map with `table_name`, `columns`, and `types`).

  ## Examples

      {:ok, queries} = PgRandomizer.generate(10, [
        %{table_name: "table", columns: ["a", "b"], types: [:integer, :string]},
        %{table_name: "table2", columns: ["a", "b"], types: [:integer, :string]},
      ])

  """
  @spec generate(pos_integer(), list(Types.table_def())) :: {:ok, list(charlist())}
  def generate(n, opts) when n > 0 do
    # create insert query for each table
    insert_queries = Enum.flat_map(opts, fn table_opts ->
        {:ok, insert_queries} = generate_inserts(n, table_opts)
        insert_queries
      end
    )

    {:ok, insert_queries}
  end

  defp generate_inserts(n, table_opts, queries \\ [])

  defp generate_inserts(0, _table_opts, queries) do
    {:ok, queries}
  end

  defp generate_inserts(n, table_opts, queries) when n > 0 do
    query = ~c"INSERT INTO #{table_opts.table_name} "
    query = query ++ ~c"\(#{Enum.join(table_opts.columns, ", ")}\) VALUES \("
    query = query ++ to_charlist(
      # generate random data for columns (based on types)
      Enum.map_join(table_opts.types, ", ", fn type ->
        Random.random(type)
      end)
    )
    query = query ++ ~c"\)"

    generate_inserts(n-1, table_opts, [query | queries])
  end
end
