defmodule EvalioApp.Meetings.Meeting do
  use Ecto.Schema
  import Ecto.Changeset

  schema "meetings" do
    field :title, :string
    field :date, :date
    field :time, :time
    field :link, :string
    field :tag, :string, default: "none"

    timestamps()
  end

  @doc false
  def changeset(meeting, attrs) do
    meeting
    |> cast(attrs, [:title, :date, :time, :link, :tag])
    |> validate_required([:title, :date, :time, :link])
  end

  @doc """
  Creates a new meeting with the given title, date, time, and link.
  """
  def new(title, date, time, link) do
    %__MODULE__{
      title: title,
      date: date,
      time: time,
      link: link,
      tag: "none"
    }
  end

  @doc """
  Updates a meeting with new title, date, time, and link.
  """
  def update(meeting, title, date, time, link) do
    %{meeting | title: title, date: date, time: time, link: link}
  end

  @doc """
  Updates a meeting's tag.
  """
  def update_tag(meeting, tag) do
    %{meeting | tag: tag}
  end
end
