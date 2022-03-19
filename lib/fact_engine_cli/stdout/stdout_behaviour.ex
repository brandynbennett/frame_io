defmodule FactEngineCLI.STDOUTBehaviour do
  @moduledoc """
  Behaviour for interacting with stdout
  """
  @callback puts(any()) :: :ok
  @callback put_error(any()) :: :ok
end
