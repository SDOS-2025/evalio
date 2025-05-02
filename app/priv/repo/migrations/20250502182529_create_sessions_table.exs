defmodule EvalioApp.Repo.Migrations.CreateSessionsTable do
  use Ecto.Migration

  def change do
    create table(:sessions, primary_key: false) do
      add :session_id, :uuid, primary_key: true
      add :cohort, :string, null: false
      add :date, :date, null: false
      add :duration, :integer, null: false
      add :transcript, :text
      add :num_attendees, :integer, null: false
      add :attendance_percentage, :float, null: false

      timestamps()
    end

    create index(:sessions, [:cohort])
    create index(:sessions, [:date])
  end
end
