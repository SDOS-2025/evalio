defmodule EvalioApp.Reminder do
  @moduledoc """
  Defines the Reminder struct and its functions.
  """
  require Logger
  defstruct [:id, :title, :date, :time]

  @doc """
  Creates a new reminder with the given title, date and time.
  """
  def new(title, date, time) do
    id = generate_unique_id()
    Logger.info("Generated new reminder ID: #{id}")
    %__MODULE__{
      id: id,
      title: title,
      date: date,
      time: time
    }
  end

  @doc """
  Updates a reminder with new title, date and time.
  """
  def update(reminder, title, date, time) do
    Logger.info("Updating reminder with ID: #{reminder.id}")
    %{reminder | title: title, date: date, time: time}
  end

  defp generate_unique_id do
    timestamp = System.system_time(:millisecond)
    random = :rand.uniform(1000)
    id = "#{timestamp}-#{random}"
    Logger.info("Generated unique ID: #{id}")
    id
  end
end 