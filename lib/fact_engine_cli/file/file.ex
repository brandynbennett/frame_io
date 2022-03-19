defmodule FactEngineCLI.File do
  @moduledoc """
  Functions for interacting with file system
  """
  @behaviour FactEngineCLI.FileBehaviour

  def stream!(path) do
    File.stream!(path)
    |> Stream.map(&String.replace(&1, "\n", ""))
  end
end
