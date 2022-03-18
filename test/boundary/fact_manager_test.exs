defmodule FactEngine.Boundary.FactManagerTest do
  use ExUnit.Case, async: false

  alias FactEngine.Boundary.FactManager

  test "new/0 creates a new Manager" do
    FactManager.new()
    assert GenServer.whereis(FactManager) |> is_pid()
  end
end
