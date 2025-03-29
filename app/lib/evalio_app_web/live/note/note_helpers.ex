defmodule EvalioAppWeb.NoteHelpers do
  use EvalioAppWeb, :live_view
  alias EvalioApp.Note

  def add_note(socket, note) do
    notes = [note | socket.assigns.notes]

    socket
    |> assign(:notes, notes)
    |> assign(:show_form, false)
    |> assign(:title, "")
    |> assign(:content, "")
  end

  def delete_note(socket, index) do
    notes =
      socket.assigns.notes
      |> Enum.with_index()
      |> Enum.reject(fn {_note, i} -> Integer.to_string(i) == index end)
      |> Enum.map(fn {note, _} -> note end)

    assign(socket, :notes, notes)
  end

  def edit_note(socket, index, updated_note) do
    notes =
      socket.assigns.notes
      |> Enum.with_index()
      |> Enum.map(fn {note, i} ->
        if Integer.to_string(i) == index do
          updated_note
        else
          note
        end
      end)

    assign(socket, :notes, notes)
  end

  def cancel_changes(socket) do
    socket
    |> assign(:show_form, false)
    |> assign(:editing_index, nil)
  end

  defp build_form(note \\ %{"title" => "", "content" => ""}) do
    to_form(note)
  end
end
