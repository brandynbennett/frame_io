defmodule FactEngine.Core.Fact do
  @moduledoc """
  Represents a Fact that our Engine knows about. e.g. `are_friends (alex, sam)`

  ## Fields

  * `statement` - The first element of a fact (e.g. `are_friends`)
  * `arguments` - The dynamic elements of a fact. In the fact `are_friends (alex, sam)`
    `alex`, and `sam` would be the arguments
  """

  defstruct statement: nil, arguments: []

  @doc """
  Create a new Fact
  """
  def new(fields \\ []) do
    struct!(__MODULE__, fields)
  end
end
