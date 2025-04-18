defmodule EvalioApp.Repo.Migrations.CreateNotesTable do
  use Ecto.Migration

  def change do
    create table(:notes) do
      add :title, :string, null: false
      add :content, :text, null: false
      add :special_words, {:array, :string}, default: []
      add :tag, :string, default: "none"
      add :pinned, :boolean, default: false
      add :created_at, :utc_datetime, null: false
      add :last_edited_at, :utc_datetime, null: false

      timestamps()
    end

    create index(:notes, [:tag])
    create index(:notes, [:pinned])
  end
end
