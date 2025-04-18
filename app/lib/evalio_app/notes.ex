defmodule EvalioApp.Notes do
  @moduledoc """
  The Notes context.
  """

  import Ecto.Query, warn: false
  alias EvalioApp.Repo
  alias EvalioApp.Notes.Note

  @doc """
  Returns the list of notes.
  """
  def list_notes do
    Repo.all(Note)
  end

  @doc """
  Gets a single note.
  """
  def get_note!(id), do: Repo.get!(Note, id)

  @doc """
  Creates a note.
  """
  def create_note(attrs \\ %{}) do
    %Note{}
    |> Note.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a note.
  """
  def update_note(%Note{} = note, attrs) do
    note
    |> Note.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a note.
  """
  def delete_note(%Note{} = note) do
    Repo.delete(note)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking note changes.
  """
  def change_note(%Note{} = note, attrs \\ %{}) do
    Note.changeset(note, attrs)
  end

  @doc """
  Updates a note's tag.
  """
  def update_note_tag(%Note{} = note, tag) do
    update_note(note, %{tag: tag})
  end

  @doc """
  Toggles a note's pinned status.
  """
  def toggle_note_pin(%Note{} = note) do
    update_note(note, %{pinned: !note.pinned})
  end

  @doc """
  Extracts special words from content (all words after # symbols).
  """
  def extract_special_words(content) do
    Regex.scan(~r/#(\w+)/, content)
    |> Enum.map(fn [_, word] -> word end)
  end
end
