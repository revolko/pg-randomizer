defprotocol MyRandom do
  @doc "Returns a random value"
  def random(r)
end

defmodule RandomInt do
  defstruct max: 100
end

defimpl MyRandom, for: RandomInt do
  def random(%RandomInt{max: max}) do
    :rand.uniform(max)
  end
end

defmodule RandomString  do
  defstruct max: 100
end

defimpl MyRandom, for: RandomString do
  def random(%RandomString{max: max}) do
    "\'#{to_string(:crypto.hash(:md5, :rand.uniform(max)) |> Base.encode16(case: :lower))}\'"
  end
end

defmodule Random do
  @moduledoc """
  Documentation for `Random`.
  """

  def random_int() do
    to_string(:rand.uniform(100))
  end

  def random_string() do
    "\'#{to_string(:crypto.hash(:md5, random_int()) |> Base.encode16(case: :lower))}\'"
  end

  def random(type) do
    case type do
      :integer ->
        Random.random_int()
      :string ->
        Random.random_string()
      _ -> {:error, "unknown type"}
    end
  end
end
