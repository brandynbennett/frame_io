defmodule FactEngine.Core.FactTest do
  use ExUnit.Case, async: false

  alias FactEngine.Core.{Fact, Query}

  describe "from_string/1" do
    test "creates new fact from two args" do
      assert {:ok, %Fact{statement: "are_friends", arguments: ["alex", "sam"]}} =
               Fact.from_string("are_friends (alex, sam)")
    end

    test "creates new fact from one arg" do
      assert {:ok, %Fact{statement: "are_friends", arguments: ["alex"]}} =
               Fact.from_string("are_friends (alex)")
    end

    test "creates new fact from three args" do
      assert {:ok, %Fact{statement: "are_friends", arguments: ["alex", "sam", "brian"]}} =
               Fact.from_string("are_friends (alex, sam, brian)")
    end

    test "creates new fact no white-space" do
      assert {:ok, %Fact{statement: "are_friends", arguments: ["alex", "sam", "brian"]}} =
               Fact.from_string("are_friends(alex,sam,brian)")
    end

    test "non-string returns errors" do
      assert {:error, "Fact.from_string/1 expects a String, got foo"} == Fact.from_string(:foo)
    end

    test "no arguments returns errors" do
      assert {:error, "Facts must have on or more arguments"} ==
               Fact.from_string("are_friends ()")
    end

    test "missing arguments returns errors" do
      assert {:error, "are_friends (sam,,brian) is not a valid fact"} ==
               Fact.from_string("are_friends (sam,,brian)")
    end

    test "unparseable returns error" do
      assert {:error, "foo is not a valid fact"} ==
               Fact.from_string("foo")
    end
  end

  describe "matches?/2" do
    test "true for 2 arg match" do
      query = Query.new(statement: "are_friends", arguments: ["alex", "sam"])

      assert Fact.new(statement: "are_friends", arguments: ["alex", "sam"])
             |> Fact.matches?(query)
    end

    test "false for different length arguments" do
      query = Query.new(statement: "are_friends", arguments: ["sam"])

      refute Fact.new(statement: "are_friends", arguments: ["alex", "sam"])
             |> Fact.matches?(query)
    end

    test "false for different statements" do
      query = Query.new(statement: "is_a_cat", arguments: ["alf"])

      refute Fact.new(statement: "are_friends", arguments: ["alex", "sam"])
             |> Fact.matches?(query)
    end
  end
end
