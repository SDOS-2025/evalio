defmodule EvalioApp.Note do
  @moduledoc """
  Defines the Note struct and its functions.
  """
  require Logger
  defstruct [:id, :title, :content, :editing]

  @doc """
  Creates a new note with the given title and content.
  """
  def new(title, content) do
    id = generate_unique_id()
    Logger.info("Generated new note ID: #{id}")
    %__MODULE__{
      id: id,
      title: title,
      content: content,
      editing: false
    }
  end

  @doc """
  Updates a note with new title and content.
  """
  def update(note, title, content) do
    Logger.info("Updating note with ID: #{note.id}")
    %{note | title: title, content: content, editing: true}
  end

  defp generate_unique_id do
    timestamp = System.system_time(:millisecond)
    random = :rand.uniform(1000)
    id = "#{timestamp}-#{random}"
    Logger.info("Generated unique ID: #{id}")
    id
  end
end
