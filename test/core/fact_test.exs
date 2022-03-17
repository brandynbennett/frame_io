defmodule FactEngine.Core.FactTest do
  use ExUnit.Case, async: false

  alias FactEngine.Core.Fact

  describe "from_string/1" do
    test "creates new fact from valid string" do
      assert {:ok, %Fact{statement: "are_friends", arguments: ["alex", "sam"]}} =
               Fact.from_string("are_friends (alex, sam)")
    end

    test "non-string returns errors" do
      assert {:error, "Fact.from_string/1 expects a String, got foo"} == Fact.from_string(:foo)
    end

    test "no arguments returns errors" do
      assert {:error, "Facts must have on or more arguments"} ==
               Fact.from_string("are_friends ()")
    end

    test "unparseable returns error" do
      assert {:error, "foo is not a valid fact"} ==
               Fact.from_string("foo")
    end
  end
end
