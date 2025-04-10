defmodule EvalioApp.Note do
  @moduledoc """
  Defines the Note struct and its functions.
  """
  require Logger
  defstruct [:id, :title, :content, :editing, :special_word, :created_at, tag: "none"]

  @doc """
  Creates a new note with the given title and content.
  """
  def new(title, content, special_word \\ nil) do
    id = generate_unique_id()
    current_time = DateTime.utc_now() |> DateTime.truncate(:second)
    Logger.info("Generated new note ID: #{id}")
    %__MODULE__{
      id: id,
      title: title,
      content: content,
      editing: false,
      special_word: special_word,
      tag: "none",
      created_at: current_time
    }
  end

  @doc """
  Updates a note with new title and content.
  """
  def update(note, title, content, special_word) do
    Logger.info("Updating note with ID: #{note.id}")
    %{note | title: title, content: content, editing: true, special_word: special_word}
  end

  @doc """
  Updates a note's tag.
  """
  def update_tag(note, tag) do
    Logger.info("Updating tag for note with ID: #{note.id} to #{tag}")
    %{note | tag: tag}
  end

  defp generate_unique_id do
    timestamp = System.system_time(:millisecond)
    random = :rand.uniform(1000)
    id = "#{timestamp}-#{random}"
    Logger.info("Generated unique ID: #{id}")
    id
  end
end
