defmodule EvalioApp.Meetings do
  @moduledoc """
  The Meetings context.
  """

  import Ecto.Query, warn: false
  alias EvalioApp.Repo
  alias EvalioApp.Meetings.Meeting

  @doc """
  Returns the list of meetings.
  """
  def list_meetings do
    Repo.all(Meeting)
  end

  @doc """
  Gets a single meeting.
  """
  def get_meeting!(id), do: Repo.get!(Meeting, id)

  @doc """
  Creates a meeting.
  """
  def create_meeting(attrs \\ %{}) do
    %Meeting{}
    |> Meeting.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a meeting.
  """
  def update_meeting(%Meeting{} = meeting, attrs) do
    meeting
    |> Meeting.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a meeting.
  """
  def delete_meeting(%Meeting{} = meeting) do
    Repo.delete(meeting)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking meeting changes.
  """
  def change_meeting(%Meeting{} = meeting, attrs \\ %{}) do
    Meeting.changeset(meeting, attrs)
  end

  @doc """
  Updates a meeting's tag.
  """
  def update_meeting_tag(%Meeting{} = meeting, tag) do
    update_meeting(meeting, %{tag: tag})
  end
end
