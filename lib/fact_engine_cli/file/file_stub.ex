defmodule FactEngineCLI.FileStub do
  @behaviour FactEngineCLI.FileBehaviour

  def stream!(_path) do
    %Stream{}
  end
end
