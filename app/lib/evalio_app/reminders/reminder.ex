defmodule EvalioApp.Reminders.Reminder do
  use Ecto.Schema
  import Ecto.Changeset

  schema "reminders" do
    field :title, :string
    field :date, :date
    field :time, :time
    field :tag, :string, default: "none"

    timestamps()
  end

  @doc false
  def changeset(reminder, attrs) do
    reminder
    |> cast(attrs, [:title, :date, :time, :tag])
    |> validate_required([:title, :date, :time])
  end

  @doc """
  Creates a new reminder with the given title, date and time.
  """
  def new(title, date, time) do
    %__MODULE__{
      title: title,
      date: date,
      time: time,
      tag: "none"
    }
  end

  @doc """
  Updates a reminder with new title, date and time.
  """
  def update(reminder, title, date, time) do
    %{reminder |
      title: title,
      date: date,
      time: time
    }
  end

  @doc """
  Updates a reminder's tag.
  """
  def update_tag(reminder, tag) do
    %{reminder | tag: tag}
  end
end
