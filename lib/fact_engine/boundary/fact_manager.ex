defmodule FactEngine.Boundary.FactManager do
  @moduledoc """

  """
  use GenServer
  alias FactEngine.Core.Fact

  @doc """
  Create a new FactManager
  """
  @spec new(list()) :: GenServer.on_start()
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
  @spec add_fact(String.t()) :: :ok | {:error, String.t()}
  def add_fact(fact) do
    GenServer.call(__MODULE__, {:add_fact, fact})
  end

  @doc """
  Get all the facts the Manager knows about

  ## Examples
      iex> FactManager.get_facts()
      [%Fact{}, %Fact{}]
  """
  @spec get_facts() :: list(Fact.t())
  def get_facts do
    GenServer.call(__MODULE__, :get_facts)
  end

  @doc """
  Query facts the Manager has

  ## Examples
      iex> FactManager.query_facts("are_friends (X, Y)")
      %{"X" => "alex", "Y" => "sam"}
  """
  @spec query_facts(String.t()) :: list(map()) | boolean | {:error, String.t()}
  def query_facts(query) do
    GenServer.call(__MODULE__, {:query_facts, query})
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

  @impl true
  def handle_call({:query_facts, query}, _from, state) do
    case Fact.from_string(query) do
      {:ok, query} ->
        {:reply, get_query_results(query, state), state}

      error ->
        {:reply, error, state}
    end
  end

  defp get_query_results(query, facts) do
    results = Enum.map(facts, &Fact.matches?(&1, query))

    map_results = Enum.filter(results, &is_map(&1))

    cond do
      Enum.count(map_results) > 0 -> map_results
      Enum.any?(results, &(&1 == true)) -> true
      true -> false
    end
  end
end
