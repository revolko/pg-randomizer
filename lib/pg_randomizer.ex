defmodule PgRandomizer do
  @moduledoc """
  Documentation for `PgRandomizer`.
  """

  @doc """
  Hello world.

  ## Examples

      iex> PgRandomizer.hello()
      :world

  """
  def hello do
    :world
  end

  @doc """
  Generator of (for now only insert) SQL queries.
  Expects number of queries to generate and
  table specification (map with `table_name`, `columns`, and `types`).

  ## Examples

      {:ok, queries } = PgRandomizer.generator(10, [
        %{table_name: "table", columns: ["a", "b"], types: [:integer, :string]},
        %{table_name: "table2", columns: ["a", "b"], types: [:integer, :string]},
      ])

  """
  @spec generator(integer, list(map())) :: {:ok, list(charlist())}
  def generator(n, opts) when n > 0 do
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
        case type do
          :integer -> 
            random_int()
          :string ->
            random_string()
          _ -> {:error, "unknown type"}
        end
      end)
    )
    query = query ++ ~c"\)"

    generate_inserts(n-1, table_opts, [query | queries])
  end

  defp random_int() do
    to_string(:rand.uniform(100))
  end

  defp random_string() do
    "\'#{to_string(:crypto.hash(:md5, random_int()) |> Base.encode16(case: :lower))}\'"
  end
end
