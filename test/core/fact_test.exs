defmodule FactEngine.Core.FactTest do
  use ExUnit.Case, async: false

  alias FactEngine.Core.Fact

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
      query = Fact.new(statement: "are_friends", arguments: ["alex", "sam"])

      assert Fact.new(statement: "are_friends", arguments: ["alex", "sam"])
             |> Fact.matches?(query)
    end

    test "true for 1 dynamic, 1 static" do
      query = Fact.new(statement: "are_friends", arguments: ["X", "sam"])

      assert Fact.new(statement: "are_friends", arguments: ["alex", "sam"])
             |> Fact.matches?(query) == %{"X" => "alex"}
    end

    test "true for 1 dynamic" do
      query = Fact.new(statement: "are_friends", arguments: ["X"])

      assert Fact.new(statement: "are_friends", arguments: ["alex"])
             |> Fact.matches?(query) == %{"X" => "alex"}
    end

    test "true for all dynamic" do
      query = Fact.new(statement: "are_friends", arguments: ["X", "Y", "Z"])

      assert Fact.new(statement: "are_friends", arguments: ["alex", "sam", "brian"])
             |> Fact.matches?(query) == %{"X" => "alex", "Y" => "sam", "Z" => "brian"}
    end

    test "true for same dynamic" do
      query = Fact.new(statement: "are_friends", arguments: ["X", "X"])

      assert Fact.new(statement: "are_friends", arguments: ["alex", "alex"])
             |> Fact.matches?(query) == %{"X" => "alex"}
    end

    test "false for different static arguments" do
      query = Fact.new(statement: "are_friends", arguments: ["bob", "frank"])

      refute Fact.new(statement: "are_friends", arguments: ["alex", "sam"])
             |> Fact.matches?(query)
    end

    test "false for different length arguments" do
      query = Fact.new(statement: "are_friends", arguments: ["sam"])

      refute Fact.new(statement: "are_friends", arguments: ["alex", "sam"])
             |> Fact.matches?(query)
    end

    test "false for different statements" do
      query = Fact.new(statement: "is_a_cat", arguments: ["alf"])

      refute Fact.new(statement: "are_friends", arguments: ["alex", "sam"])
             |> Fact.matches?(query)
    end

    test "false for same dynamic when facts are different" do
      query = Fact.new(statement: "are_friends", arguments: ["X", "X"])

      refute Fact.new(statement: "are_friends", arguments: ["alex", "sam"])
             |> Fact.matches?(query)
    end
  end
end
