defmodule FactEngineCLI do
  @moduledoc """
  Interact with the FactEngine via a CLI interface
  """

  alias FactEngine.Boundary.FactManager

  @query_header "---\n"

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

  defp process_line("QUERY " <> query) do
    case FactManager.query_facts(query) do
      {:error, message} -> stdout().put_error("ERROR #{message}")
      results -> stdout().puts(format_query_results(results))
    end
  end

  defp stdout do
    Application.get_env(:fact_engine, :stdout)
  end

  defp format_query_results(results) when is_map(results) do
    Enum.map_join(results, ", ", fn {key, value} ->
      "#{key}: #{value}"
    end)
  end

  defp format_query_results(results) when is_list(results) do
    Enum.reduce(results, @query_header, fn result, acc ->
      acc <> "#{format_query_results(result)}\n"
    end)
  end

  defp format_query_results(results) do
    "#{@query_header}#{results}\n"
  end
end
