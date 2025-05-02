defmodule EvalioApp.Cohort do
  @moduledoc """
  Defines the Cohort struct and its functions.
  """
  require Logger

  defstruct [
    :id,
    :name,
    :batch,
    :year,
    :mentee_count
  ]

  @doc """
  Loads all cohorts from the database.
  """
  def list_cohorts do
    case Ecto.Adapters.SQL.query(EvalioApp.Repo, """
           SELECT id, name, batch, year, mentee_count
           FROM cohorts
           ORDER BY year DESC, name;
         """) do
      {:ok, %{rows: rows}} ->
        Enum.map(rows, &row_to_struct/1)

      {:error, error} ->
        Logger.error("Failed to fetch cohorts: #{inspect(error)}")
        []
    end
  end

  defp row_to_struct([id, name, batch, year, mentee_count]) do
    %__MODULE__{
      id: id,
      name: name,
      batch: batch,
      year: year,
      mentee_count: mentee_count
    }
  end
end
