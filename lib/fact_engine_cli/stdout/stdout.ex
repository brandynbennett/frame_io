defmodule FactEngineCLI.STDOUT do
  @moduledoc """
  Functions for interacting with stdout
  """
  @behaviour FactEngineCLI.STDOUTBehaviour

  def puts(device \\ :stdio, data) do
    IO.puts(device, data)
  end
end
