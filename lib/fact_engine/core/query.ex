defmodule FactEngine.Core.Query do
  @moduledoc """
  Represents a Query that our Engine can use to lookup facts. e.g. `are_friends (X, sam)`

  ## Fields

  * `statement` - The kind of fact to lookup (e.g. `are_friends`)
  * `arguments` - The dynamic elements of the query. In the query `are_friends (X, sam)`
    `X` would be a dynamic argument, and "sam" would be a static one
  """

  @type t :: %__MODULE__{
          statement: String.t() | nil,
          arguments: [String.t()]
        }

  defstruct statement: nil, arguments: []

  @query_regex ~r/^([\w_]+)\s?\(((?:\w+)*(?:,\s?\w+)*)\)$/

  @doc """
  Create a new Query
  """
  @spec new(keyword()) :: t()
  def new(fields \\ []) do
    struct!(__MODULE__, fields)
  end

  @doc """
  Create a new query from a string representation

  ## Examples
      iex> Query.from_string("are_friends (alex, sam)")
      {:ok, %Query{statement: "are_friends", arguments: ["alex", "sam"]}}

      iex> Query.from_string(:foo)
      {:error, ":foo is not a valid query"}
  """
  @spec from_string(String.t()) :: {:ok, t()} | {:error, String.t()}
  def from_string(str) when is_binary(str) do
    Regex.run(@query_regex, str, capture: :all_but_first)
    |> from_list(str)
  end

  def from_string(str) do
    {:error, "Fact.from_string/1 expects a String, got #{str}"}
  end

  defp from_list(nil, str) do
    {:error, "#{str} is not a valid fact"}
  end

  defp from_list([_statement], _str) do
    {:error, "Facts must have on or more arguments"}
  end

  defp from_list([_statement, ""], _str) do
    {:error, "Facts must have on or more arguments"}
  end

  defp from_list([statement, arguments], _str) do
    {:ok, new(statement: statement, arguments: split_arguments(arguments))}
  end

  defp split_arguments(arguments) do
    String.split(arguments, ",") |> Enum.map(&String.trim/1)
  end
end
