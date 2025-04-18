defmodule EvalioApp.NotesTest do
  use EvalioApp.DataCase

  alias EvalioApp.Notes
  alias EvalioApp.Notes.Note

  describe "notes" do
    @valid_attrs %{
      title: "Test Note",
      content: "Test Content",
      special_words: ["test", "content"],
      tag: "none",
      pinned: false,
      created_at: DateTime.utc_now() |> DateTime.truncate(:second),
      last_edited_at: DateTime.utc_now() |> DateTime.truncate(:second)
    }
    @update_attrs %{
      title: "Updated Note",
      content: "Updated Content",
      special_words: ["updated", "content"],
      tag: "none",
      pinned: false,
      created_at: DateTime.utc_now() |> DateTime.truncate(:second),
      last_edited_at: DateTime.utc_now() |> DateTime.truncate(:second)
    }
    @invalid_attrs %{title: nil, content: nil, created_at: nil, last_edited_at: nil}

    def note_fixture(attrs \\ %{}) do
      {:ok, note} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Notes.create_note()

      note
    end

    test "list_notes/0 returns all notes" do
      note = note_fixture()
      assert Notes.list_notes() == [note]
    end

    test "get_note!/2 returns the note with given id" do
      note = note_fixture()
      assert Notes.get_note!(note.id) == note
    end

    test "create_note/1 with valid data creates a note" do
      assert {:ok, %Note{} = note} = Notes.create_note(@valid_attrs)
      assert note.title == "Test Note"
      assert note.content == "Test Content"
      assert note.special_words == ["test", "content"]
      assert note.tag == "none"
      assert note.pinned == false
    end

    test "create_note/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Notes.create_note(@invalid_attrs)
    end

    test "update_note/2 with valid data updates the note" do
      note = note_fixture()
      assert {:ok, %Note{} = note} = Notes.update_note(note, @update_attrs)
      assert note.title == "Updated Note"
      assert note.content == "Updated Content"
      assert note.special_words == ["updated", "content"]
    end

    test "update_note/2 with invalid data returns error changeset" do
      note = note_fixture()
      assert {:error, %Ecto.Changeset{}} = Notes.update_note(note, @invalid_attrs)
      assert note == Notes.get_note!(note.id)
    end

    test "delete_note/1 deletes the note" do
      note = note_fixture()
      assert {:ok, %Note{}} = Notes.delete_note(note)
      assert_raise Ecto.NoResultsError, fn -> Notes.get_note!(note.id) end
    end

    test "change_note/1 returns a note changeset" do
      note = note_fixture()
      assert %Ecto.Changeset{} = Notes.change_note(note)
    end

    test "update_note_tag/2 updates the note's tag" do
      note = note_fixture()
      assert {:ok, %Note{} = updated_note} = Notes.update_note_tag(note, "important")
      assert updated_note.tag == "important"
    end

    test "toggle_note_pin/1 toggles the note's pinned status" do
      note = note_fixture()
      assert {:ok, %Note{} = updated_note} = Notes.toggle_note_pin(note)
      assert updated_note.pinned == true
      assert {:ok, %Note{} = updated_note} = Notes.toggle_note_pin(updated_note)
      assert updated_note.pinned == false
    end
  end
end
