defmodule FactEngineCLI.FileBehaviour do
  @moduledoc """
  Behaviour for interacting with the file system
  """
  @callback stream!(Path.t()) :: Stream.t() | File.Stream.t()
end
