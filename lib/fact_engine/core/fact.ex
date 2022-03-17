defmodule FactEngine.Core.Fact do
  @moduledoc """
  Represents a Fact that our Engine knows about. e.g. `are_friends (alex, sam)`

  ## Fields

  * `statement` - The first element of a fact (e.g. `are_friends`)
  * `arguments` - The dynamic elements of a fact. In the fact `are_friends (alex, sam)`
    `alex`, and `sam` would be the arguments
  """

  alias FactEngine.Core.Query

  @type t :: %__MODULE__{
          statement: String.t() | nil,
          arguments: [String.t()]
        }

  defstruct statement: nil, arguments: []

  @fact_regex ~r/^([\w_]+)\s?\(((?:\w+)*(?:,\s?\w+)*)\)$/

  @doc """
  Create a new Fact
  """
  @spec new(keyword()) :: t()
  def new(fields \\ []) do
    struct!(__MODULE__, fields)
  end

  @doc """
  Create a new fact from a string representation

  ## Examples
      iex> Fact.from_string("are_friends (alex, sam)")
      {:ok, %Fact{statement: "are_friends", arguments: ["alex", "sam"]}}

      iex> Fact.from_string(:foo)
      {:error, ":foo is not a valid fact"}
  """
  @spec from_string(String.t()) :: {:ok, t()} | {:error, String.t()}
  def from_string(str) when is_binary(str) do
    Regex.run(@fact_regex, str, capture: :all_but_first)
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

  @doc """
  Determines if a fact matches query

  ## Examples
      iex> query = Query.new(statement: "are_friends", arguments: ["alex", "sam"])
      iex> Fact.new(statement: "are_friends", arguments: ["alex", "sam"])
      ... |> Fact.matches?(query)
      true

      iex> query = Query.new(statement: "are_friends", arguments: ["X", "Y"])
      iex> Fact.new(statement: "are_friends", arguments: ["alex", "sam"])
      ... |> Fact.matches?(query)
      %{X: "alex", Y: "sam"}
  """
  def matches?(%__MODULE__{} = fact, %Query{} = query) do
    statements_match?(fact.statement, query.statement)
  end

  defp statements_match?(statement1, statement2) do
    statement1 == statement2
  end
end
