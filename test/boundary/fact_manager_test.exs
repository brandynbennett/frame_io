defmodule FactEngine.Boundary.FactManagerTest do
  use ExUnit.Case, async: false

  alias FactEngine.Boundary.FactManager
  alias FactEngine.Core.Fact

  test "new/0 creates a new Manager" do
    FactManager.new()
    assert GenServer.whereis(FactManager) |> is_pid()
  end

  test "add_fact/1 adds a fact" do
    FactManager.new()
    assert FactManager.add_fact("are_friends (alex, sam)") == :ok

    assert [%Fact{statement: "are_friends", arguments: ["alex", "sam"]}] ==
             FactManager.get_facts()
  end

  test "add_fact/1 gives error for invalid fact" do
    FactManager.new()
    assert FactManager.add_fact("foo") == {:error, "foo is not a valid fact"}
  end
end
