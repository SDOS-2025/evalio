defmodule EvalioApp.Note do
  @moduledoc """
  Defines the Note struct and its functions.
  """
  defstruct [:title, :content, :editing]

  @doc """
  Creates a new note with the given title and content.
  """
  def new(title, content) do
    %__MODULE__{
      title: title,
      content: content,
      editing: false
    }
  end

  @doc """
  Updates a note with new title and content.
  """
  def update(note, title, content) do
    %{note | title: title, content: content, editing: true}
  end
end
