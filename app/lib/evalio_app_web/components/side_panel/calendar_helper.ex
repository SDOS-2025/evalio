defmodule EvalioAppWeb.CalendarHelper do
  @moduledoc """
  Helper functions for calendar formatting and display.
  """

  @month_names [
    "January", "February", "March", "April", "May", "June",
    "July", "August", "September", "October", "November", "December"
  ]

  @doc """
  Returns the name of the month for the given month number (1-12).
  """
  def month_name(month) when is_integer(month) and month >= 1 and month <= 12 do
    Enum.at(@month_names, month - 1)
  end

  @doc """
  Formats a date as a string in the format "DD-MM-YYYY".
  """
  def format_date(date) do
    "#{String.pad_leading("#{date.day}", 2, "0")}-#{String.pad_leading("#{date.month}", 2, "0")}-#{date.year}"
  end

  @doc """
  Formats a time as a string in the format "HH:MM".
  """
  def format_time(time) when is_binary(time) do
    time
  end

  @doc """
  Converts reminders and meetings to calendar events.
  """
  def convert_to_events(reminders, meetings) do
    reminder_events =
      Enum.map(reminders, fn reminder ->
        %{
          id: reminder.id,
          title: reminder.title,
          date: parse_date(reminder.date),
          time: reminder.time,
          type: :reminder
        }
      end)

    meeting_events =
      Enum.map(meetings, fn meeting ->
        %{
          id: meeting.id,
          title: meeting.title,
          date: parse_date(meeting.date),
          time: meeting.time,
          type: :meeting
        }
      end)

    reminder_events ++ meeting_events
  end

  @doc """
  Parses a date string in the format "YYYY-MM-DD" to a Date struct.
  """
  def parse_date(date) when is_binary(date) do
    case Date.from_iso8601(date) do
      {:ok, date} -> date
      _ -> nil
    end
  end

  def parse_date(%Date{} = date) do
    date
  end
end
