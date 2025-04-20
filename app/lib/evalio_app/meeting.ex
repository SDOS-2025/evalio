defmodule EvalioApp.Meeting do
  @moduledoc """
  Defines the Meeting struct and its functions.
  """
  require Logger
  defstruct [:id, :title, :date, :time, :link, :tag]

  @doc """
  Creates a new meeting with the given title, date, time, and link.
  """
  def new(title, date, time, link) do
    id = generate_unique_id()
    Logger.info("Generated new meeting ID: #{id}")

    %__MODULE__{
      id: id,
      title: title,
      date: date,
      time: time,
      link: link,
      tag: "none"
    }
  end

  @doc """
  Updates a meeting with new title, date, time, and link.
  """
  def update(meeting, title, date, time, link) do
    Logger.info("Updating meeting with ID: #{meeting.id}")
    %{meeting | title: title, date: date, time: time, link: link}
  end

  @doc """
  Updates a meeting's tag.
  """
  def update_tag(meeting, tag) do
    Logger.info("Updating meeting tag with ID: #{meeting.id}")
    %{meeting | tag: tag}
  end

  defp generate_unique_id do
    timestamp = System.system_time(:millisecond)
    random = :rand.uniform(1000)
    id = "#{timestamp}-#{random}"
    Logger.info("Generated unique ID: #{id}")
    id
  end
end
