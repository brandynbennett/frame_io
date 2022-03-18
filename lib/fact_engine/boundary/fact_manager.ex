defmodule FactEngine.Boundary.FactManager do
  @moduledoc """

  """
  use GenServer
  alias FactEngine.Core.Fact

  @doc """
  Create a new FactManager
  """
  def new(state \\ []) do
    GenServer.start_link(__MODULE__, state, name: __MODULE__)
  end

  @doc """
  Add a fact to the Manager

  ## Examples
      iex> FactManager.add_fact("are_friends (alex, sam)")
      :ok

      iex> FactManager.add_fact("foo")
      {:error, "foo is not a valid fact"}

  """
  def add_fact(fact) do
    GenServer.call(__MODULE__, {:add_fact, fact})
  end

  @doc """
  Get all the facts the manager knows about

  ## Examples
      iex> FactManager.get_facts()
      [%Fact{}, %Fact{}]
  """
  def get_facts do
    GenServer.call(__MODULE__, :get_facts)
  end

  @impl true
  def init(state \\ []) do
    {:ok, state}
  end

  @impl true
  def handle_call({:add_fact, fact}, _from, state) do
    case Fact.from_string(fact) do
      {:ok, fact} ->
        {:reply, :ok, Enum.concat(state, [fact])}

      error ->
        {:reply, error, state}
    end
  end

  @impl true
  def handle_call(:get_facts, _from, state) do
    {:reply, state, state}
  end
end
