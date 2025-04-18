defmodule EvalioApp.Repo.Migrations.CreateRemindersTable do
  use Ecto.Migration

  def change do
    create table(:reminders) do
      add :title, :string, null: false
      add :date, :date, null: false
      add :time, :time, null: false
      add :tag, :string, default: "none"

      timestamps()
    end

    create index(:reminders, [:date])
    create index(:reminders, [:tag])
  end
end
