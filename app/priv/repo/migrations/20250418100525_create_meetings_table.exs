defmodule EvalioApp.Repo.Migrations.CreateMeetingsTable do
  use Ecto.Migration

  def change do
    create table(:meetings) do
      add :title, :string, null: false
      add :date, :date, null: false
      add :time, :time, null: false
      add :link, :string, null: false
      add :tag, :string, default: "none"

      timestamps()
    end

    create index(:meetings, [:date])
    create index(:meetings, [:tag])
  end
end
