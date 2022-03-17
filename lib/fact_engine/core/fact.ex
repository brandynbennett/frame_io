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
      %Fact{statement: "are_friends", arguments: ["alex", "sam"]}
  """
  @spec from_string(String.t()) :: t()
  def from_string(_str) do
    new()
  end
end
