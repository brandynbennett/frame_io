defmodule FactEngine.Boundary.FactManager do
  use GenServer

  def new(state \\ []) do
    GenServer.start_link(__MODULE__, state, name: __MODULE__)
  end

  @impl true
  def init(state \\ []) do
    {:ok, state}
  end
end
