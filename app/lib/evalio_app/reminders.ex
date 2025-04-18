defmodule EvalioApp.Reminders do
  @moduledoc """
  The Reminders context.
  """

  import Ecto.Query, warn: false
  alias EvalioApp.Repo
  alias EvalioApp.Reminders.Reminder

  @doc """
  Returns the list of reminders.
  """
  def list_reminders do
    Repo.all(Reminder)
  end

  @doc """
  Gets a single reminder.
  """
  def get_reminder!(id), do: Repo.get!(Reminder, id)

  @doc """
  Creates a reminder.
  """
  def create_reminder(attrs \\ %{}) do
    %Reminder{}
    |> Reminder.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a reminder.
  """
  def update_reminder(%Reminder{} = reminder, attrs) do
    reminder
    |> Reminder.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a reminder.
  """
  def delete_reminder(%Reminder{} = reminder) do
    Repo.delete(reminder)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking reminder changes.
  """
  def change_reminder(%Reminder{} = reminder, attrs \\ %{}) do
    Reminder.changeset(reminder, attrs)
  end

  @doc """
  Updates a reminder's tag.
  """
  def update_reminder_tag(%Reminder{} = reminder, tag) do
    update_reminder(reminder, %{tag: tag})
  end
end
