defmodule FactEngineCLI.STDOUTStub do
  @behaviour FactEngineCLI.STDOUTBehaviour

  def puts(_device, _path) do
    :ok
  end
end
