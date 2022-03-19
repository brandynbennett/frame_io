defmodule FactEngineCLI.STDOUTStub do
  @behaviour FactEngineCLI.STDOUTBehaviour

  def puts(_path) do
    :ok
  end

  def put_error(path) do
    path
  end
end
