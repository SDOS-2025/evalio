defmodule EvalioAppWeb.NoteHelpers do
  use EvalioAppWeb, :live_view
  require Logger
  alias EvalioApp.Note
  alias EvalioApp.Notes

  def add_note(socket, note) do
    now = DateTime.utc_now() |> DateTime.truncate(:second)

    case Notes.create_note(%{
           title: note.title,
           content: note.content,
           tag: note.tag || "none",
           pinned: note.pinned || false,
           created_at: now,
           last_edited_at: now,
           special_words: note.special_words || []
         }) do
      {:ok, saved_note} ->
        Logger.info("Note added successfully: #{inspect(saved_note)}")
        assign(socket, notes: [saved_note | socket.assigns.notes])

      {:error, changeset} ->
        Logger.error("Failed to add note: #{inspect(changeset.errors)}")
        socket
    end
  end

  def delete_note(socket, id) do
    case Notes.get_note!(id) do
      nil ->
        socket

      note ->
        case Notes.delete_note(note) do
          {:ok, _} ->
            Logger.info("Note deleted successfully: #{id}")
            assign(socket, notes: Enum.reject(socket.assigns.notes, &(&1.id == id)))

          {:error, _} ->
            Logger.error("Failed to delete note: #{id}")
            socket
        end
    end
  end

  def edit_note(socket, id, note) do
    case Notes.get_note!(id) do
      nil ->
        socket

      existing_note ->
        now = DateTime.utc_now() |> DateTime.truncate(:second)

        case Notes.update_note(existing_note, %{
               title: note.title,
               content: note.content,
               tag: note.tag || existing_note.tag,
               pinned: note.pinned || existing_note.pinned,
               last_edited_at: now,
               special_words: note.special_words || existing_note.special_words
             }) do
          {:ok, updated_note} ->
            Logger.info("Note updated successfully: #{inspect(updated_note)}")

            assign(socket,
              notes:
                Enum.map(socket.assigns.notes, fn n ->
                  if n.id == id, do: updated_note, else: n
                end)
            )

          {:error, changeset} ->
            Logger.error("Failed to update note: #{inspect(changeset.errors)}")
            socket
        end
    end
  end

  def cancel_changes(socket) do
    socket
    |> assign(:show_form, false)
    |> assign(:editing_id, nil)
  end

  defp build_form(note \\ %{"title" => "", "content" => ""}) do
    to_form(note)
  end
end
