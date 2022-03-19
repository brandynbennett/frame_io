defmodule FactEngineCLI.STDOUTBehaviour do
  @moduledoc """
  Behaviour for interacting with stdout
  """
  @callback puts(IO.device(), any()) :: :ok
end
