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

  @spec generator(integer, map, charlist()) :: {:ok, charlist()}
  def generator(n, opts, query \\ ~c"")

  def generator(0, _opts, query) do
    {:ok, query}
  end

  def generator(n, opts, query) when n > 0 do
    res = Enum.reduce(opts, query, 
      fn {k, v}, acc ->
        acc ++ ~c"#{k} " ++ case v do
          :integer -> 
            random_int()
          :string ->
            random_string()
          _ -> {:error, "unknown type"}
      end
      ++ ~c" "
    end)
    generator(n - 1, opts, res)
  end

  defp random_int() do
    to_charlist(:rand.uniform(100))
  end

  defp random_string() do
    to_charlist(:crypto.hash(:md5, random_int()) |> Base.encode16(case: :lower))
  end
end
