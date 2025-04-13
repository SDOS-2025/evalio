defmodule EvalioAppWeb.TagManager do
  @moduledoc """
  Manages tag updates for reminders and meetings.
  This module provides functions to update tags without modifying the EvalioApp context.
  """

  alias EvalioApp.Reminder
  alias EvalioApp.Meeting

  @doc """
  Updates a reminder's tag.
  """
  def update_reminder_tag(reminder, tag) do
    Reminder.update_tag(reminder, tag)
  end

  @doc """
  Updates a meeting's tag.
  """
  def update_meeting_tag(meeting, tag) do
    Meeting.update_tag(meeting, tag)
  end
end 