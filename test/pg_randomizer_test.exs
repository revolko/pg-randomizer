defmodule PgRandomizerTest do
  use ExUnit.Case
  doctest PgRandomizer

  test "greets the world" do
    assert PgRandomizer.hello() == :world
  end

  test "happy path" do
    {res, query} = PgRandomizer.generator(2, %{a: :integer, b: :string})
    assert res == :ok
    assert is_list(query)
  end
end
