defmodule Mix.Tasks.FactEngine do
  @shortdoc "Run the FactEngine"
  @moduledoc """
  Use this task to run the fact engine. Give it a file
  path with proper INPUT and QUERY instructions to
  see results

  ## Examples

      mix fact_engine "/instructions/examples/1/in.txt"
  """
  use Mix.Task
  alias FactEngineCLI

  @impl Mix.Task
  def run(path) do
    FactEngineCLI.read_file(path)
  end
end
