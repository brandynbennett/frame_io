defmodule FactEngineCliTest do
  use ExUnit.Case

  import Mox
  setup :verify_on_exit!

  describe "read_file/1" do
    test "takes inputs" do
      stream =
        ~s[INPUT are_friends (alex, sam)\n)] <>
          ~s[INPUT are_friends (frog, toad)\n]

      FactEngineCLI.read_file(stream) == ""
    end
  end

  defp input_stream(data) do
    {:ok, stream} = StringIO.open(data)
    stream |> IO.binstream(:line)
  end
end
