defmodule EvalioAppWeb.NoteHelpers do
  use EvalioAppWeb, :live_view
  require Logger
  alias EvalioApp.Note

  def add_note(socket, note) do
    notes = [note | socket.assigns.notes]
    Logger.info("Added note with ID: #{note.id}")
    Logger.info("Current notes: #{inspect(notes)}")

    socket
    |> assign(:notes, notes)
    |> assign(:show_form, false)
    |> assign(:title, "")
    |> assign(:content, "")
  end

  def delete_note(socket, id) do
    Logger.info("Deleting note with ID: #{id}")
    notes = Enum.reject(socket.assigns.notes, &(&1.id == id))
    Logger.info("Deleted note with ID: #{id}")
    Logger.info("Current notes: #{inspect(notes)}")
    assign(socket, :notes, notes)
  end

  def edit_note(socket, id, updated_note) do
    notes =
      Enum.map(socket.assigns.notes, fn note ->
        if note.id == id do
          Logger.info("Editing note with ID: #{id}")
          Logger.info("Updated note: #{inspect(updated_note)}")
          updated_note
        else
          note
        end
      end)

    Logger.info("Current notes after edit: #{inspect(notes)}")
    assign(socket, :notes, notes)
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
