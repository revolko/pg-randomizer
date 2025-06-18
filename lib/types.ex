defmodule Types do
  @type table_def :: %{
    required(:table_name) => String.t(),
    required(:columns) => [String.t()],
    required(:types) => [atom()]
  }
end
