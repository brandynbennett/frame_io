defmodule FactEngineCliTest do
  use ExUnit.Case

  alias FactEngineCLI.FileMock
  alias FactEngineCLI.STDOUTMock

  import Mox
  setup :verify_on_exit!

  describe "read_file/1" do
    test "takes inputs" do
      expect(FileMock, :stream!, fn "in.txt" ->
        data =
          ~s[INPUT are_friends (alex, sam)\n] <>
            ~s[INPUT are_friends (frog, toad)\n]

        input_stream(data)
      end)

      expect(STDOUTMock, :put_error, 0, fn _message -> :ok end)

      assert FactEngineCLI.read_file("in.txt")
    end

    test "input errors show in console" do
      expect(FileMock, :stream!, fn "in.txt" ->
        data =
          ~s[INPUT are_friends ()\n] <>
            ~s[INPUT foo\n]

        input_stream(data)
      end)

      expect(STDOUTMock, :put_error, 2, fn
        "ERROR Facts must have on or more arguments" -> :ok
        "ERROR foo is not a valid fact" -> :ok
      end)

      assert FactEngineCLI.read_file("in.txt")
    end
  end

  defp input_stream(data) do
    {:ok, stream} = StringIO.open(data)
    stream |> IO.binstream(:line)
  end
end
