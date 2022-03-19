defmodule FactEngineCLI.STDOUT do
  @moduledoc """
  Functions for interacting with stdout
  """
  @behaviour FactEngineCLI.STDOUTBehaviour

  def puts(data) do
    IO.puts(data)
  end

  def put_error(data) do
    IO.puts(:stderr, data)
  end
end
