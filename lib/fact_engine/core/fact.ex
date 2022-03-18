defmodule FactEngine.Core.Fact do
  @moduledoc """
  Represents a Fact that our Engine knows about. e.g. `are_friends (alex, sam)`

  ## Fields

  * `statement` - The first element of a fact (e.g. `are_friends`)
  * `arguments` - The dynamic elements of a fact. In the fact `are_friends (alex, sam)`
    `alex`, and `sam` would be the arguments
  """

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
      %{"X" => "alex", "Y" => "sam"}

      iex> query = Query.new(statement: "are_friends", arguments: ["X", "Y"])
      iex> Fact.new(statement: "are_friends", arguments: ["alex", "sam", "brian"])
      ... |> Fact.matches?(query)
      false
  """
  def matches?(%__MODULE__{} = fact, %__MODULE__{} = query) do
    fact_args = fact.arguments
    query_args = query.arguments

    with true <- statements_match?(fact.statement, query.statement),
         true <- same_number_of_arguments?(fact_args, query_args),
         result <- arguments_match?(fact_args, query_args) do
      result
    end
  end

  defp statements_match?(statement1, statement2) do
    statement1 == statement2
  end

  defp same_number_of_arguments?(fact_args, query_args) do
    Enum.count(fact_args) == Enum.count(query_args)
  end

  defp arguments_match?(fact_args, query_args) do
    if dynamic_query?(query_args) do
      test_dynamic_query(fact_args, query_args)
    else
      test_static_query(fact_args, query_args)
    end
  end

  defp dynamic_query?(query_args) do
    Enum.any?(query_args, &dynamic_argument?/1)
  end

  defp dynamic_argument?(arg) do
    Regex.match?(~r/[A-Z]/, String.at(arg, 0))
  end

  defp test_dynamic_query(fact_args, query_args) do
    Enum.with_index(fact_args)
    |> Enum.reduce([], fn {fact_arg, index}, acc ->
      combine_args(acc, fact_arg, Enum.at(query_args, index))
    end)
    |> Enum.group_by(&elem(&1, 0))
    |> Enum.reduce_while(%{}, fn {query_arg, fact_args}, acc ->
      fact_args = Enum.map(fact_args, &elem(&1, 1))

      if args_all_same?(fact_args) do
        {:cont, Map.put(acc, query_arg, Enum.at(fact_args, 0))}
      else
        {:halt, false}
      end
    end)
  end

  defp combine_args(args, fact_arg, query_arg) do
    if dynamic_argument?(query_arg) do
      [{query_arg, fact_arg} | args]
    else
      args
    end
  end

  defp args_all_same?([_arg]), do: true

  defp args_all_same?([first_arg | other_args]) do
    Enum.all?(other_args, &(&1 == first_arg))
  end

  defp test_static_query(fact_args, query_args) do
    Enum.with_index(fact_args)
    |> Enum.map(fn {fact_arg, index} ->
      fact_arg == Enum.at(query_args, index)
    end)
    |> Enum.all?(&(&1 == true))
  end
end
