defmodule EvalioApp.Note do
  @moduledoc """
  Defines the Note struct and its functions.
  """
  require Logger
  defstruct [:id, :title, :content, :editing, :special_words, :created_at, :last_edited_at, tag: "none", pinned: false]

  @doc """
  Creates a new note with the given title and content.
  """
  def new(title, content, special_words \\ []) do
    id = generate_unique_id()
    current_time = DateTime.utc_now() |> DateTime.truncate(:second)
    Logger.info("Generated new note ID: #{id}")
    %__MODULE__{
      id: id,
      title: title,
      content: content,
      editing: false,
      special_words: special_words,
      tag: "none",
      pinned: false,
      created_at: current_time,
      last_edited_at: current_time
    }
  end

  @doc """
  Updates a note with new title and content.
  """
  def update(note, title, content, special_words) do
    current_time = DateTime.utc_now() |> DateTime.truncate(:second)
    Logger.info("Updating note with ID: #{note.id}")
    %{note | title: title, content: content, editing: true, special_words: special_words, last_edited_at: current_time}
  end

  @doc """
  Updates a note's tag.
  """
  def update_tag(note, tag) do
    current_time = DateTime.utc_now() |> DateTime.truncate(:second)
    Logger.info("Updating tag for note with ID: #{note.id} to #{tag}")
    %{note | tag: tag, last_edited_at: current_time}
  end

  @doc """
  Toggles the pinned status of a note.
  """
  def toggle_pin(note) do
    current_time = DateTime.utc_now() |> DateTime.truncate(:second)
    Logger.info("Toggling pin status for note with ID: #{note.id} to #{!note.pinned}")
    %{note | pinned: !note.pinned, last_edited_at: current_time}
  end

  defp generate_unique_id do
    timestamp = System.system_time(:millisecond)
    random = :rand.uniform(1000)
    id = "#{timestamp}-#{random}"
    Logger.info("Generated unique ID: #{id}")
    id
  end
end
