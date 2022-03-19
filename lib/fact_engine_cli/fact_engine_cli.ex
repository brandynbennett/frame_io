defmodule FactEngineCLI do
  @moduledoc """
  Interact with the FactEngine via a CLI interface
  """

  alias FactEngine.Boundary.FactManager

  @doc """
  Read in file of FactEngine commands and perform operations on them
  """
  @spec read_file(Path.d()) :: :ok
  def read_file(path) do
    FactManager.new()

    file().stream!(path)
    |> Stream.map(&String.replace(&1, "\n", ""))
    |> Enum.each(&process_line/1)
  end

  defp file do
    Application.get_env(:fact_engine, :file)
  end

  defp process_line("INPUT " <> fact) do
    case FactManager.add_fact(fact) do
      {:error, message} -> stdout().put_error("ERROR #{message}")
      _ -> :ok
    end
  end

  defp stdout do
    Application.get_env(:fact_engine, :stdout)
  end
end
