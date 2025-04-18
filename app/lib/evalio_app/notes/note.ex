defmodule EvalioApp.Notes.Note do
  use Ecto.Schema
  import Ecto.Changeset

  schema "notes" do
    field :title, :string
    field :content, :string
    field :special_words, {:array, :string}, default: []
    field :tag, :string, default: "none"
    field :pinned, :boolean, default: false
    field :created_at, :utc_datetime
    field :last_edited_at, :utc_datetime

    timestamps()
  end

  @doc false
  def changeset(note, attrs) do
    note
    |> cast(attrs, [:title, :content, :special_words, :tag, :pinned, :created_at, :last_edited_at])
    |> validate_required([:title, :content, :created_at, :last_edited_at])
  end

  @doc """
  Creates a new note with the given title and content.
  """
  def new(title, content, special_words \\ []) do
    current_time = DateTime.utc_now() |> DateTime.truncate(:second)

    %__MODULE__{
      title: title,
      content: content,
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

    %{note |
      title: title,
      content: content,
      special_words: special_words,
      last_edited_at: current_time
    }
  end

  @doc """
  Updates a note's tag.
  """
  def update_tag(note, tag) do
    current_time = DateTime.utc_now() |> DateTime.truncate(:second)

    %{note |
      tag: tag,
      last_edited_at: current_time
    }
  end

  @doc """
  Toggles the pinned status of a note.
  """
  def toggle_pin(note) do
    current_time = DateTime.utc_now() |> DateTime.truncate(:second)

    %{note |
      pinned: !note.pinned,
      last_edited_at: current_time
    }
  end
end
