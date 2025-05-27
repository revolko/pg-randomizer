{:ok, query } = PgRandomizer.generator(2, %{a: :integer, b: :string})

IO.puts(query)
