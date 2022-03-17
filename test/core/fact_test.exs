defmodule FactEngine.Core.FactTest do
  use ExUnit.Case, async: false

  alias FactEngine.Core.Fact

  describe "from_string/1" do
    test "creates new fact from valid string" do
      assert %Fact{statement: "are_friends", arguments: ["alex", "sam"]} =
               Fact.from_string("are_friends (alex, sam)")
    end
  end
end
