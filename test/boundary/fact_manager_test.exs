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

  test "query_facts/1 gives map result" do
    FactManager.new([
      Fact.new(statement: "is_a_cat", arguments: ["garfield"]),
      Fact.new(statement: "are_friends", arguments: ["alex", "sam"]),
      Fact.new(statement: "are_friends", arguments: ["jane", "bob"])
    ])

    assert FactManager.query_facts("are_friends (X, Y)") == [
             %{"X" => "alex", "Y" => "sam"},
             %{"X" => "jane", "Y" => "bob"}
           ]
  end

  test "query_facts/1 gives true result" do
    FactManager.new([
      Fact.new(statement: "are_friends", arguments: ["alex", "sam"]),
      Fact.new(statement: "are_friends", arguments: ["jane", "bob"])
    ])

    assert FactManager.query_facts("are_friends (alex, sam)") == true
  end

  test "query_facts/1 gives false result" do
    FactManager.new([
      Fact.new(statement: "are_friends", arguments: ["alex", "sam"]),
      Fact.new(statement: "are_friends", arguments: ["jane", "bob"])
    ])

    assert FactManager.query_facts("are_friends (smurf, foo)") == false
  end
end
