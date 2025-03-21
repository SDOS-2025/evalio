defmodule EvalioAppWeb.NoteHelpers do
  use EvalioAppWeb, :live_view

  def add_note(socket, title, content) do
    new_note = %{title: title, content: content}
    notes = [new_note | socket.assigns.notes]

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

  def edit_note(socket, index, new_title, new_content) do
    notes =
      socket.assigns.notes
      |> Enum.with_index()
      |> Enum.map(fn {note, i} ->
        if Integer.to_string(i) == index do
          %{title: new_title, content: new_content} # Update note
        else
          note
        end
      end)

    assign(socket, :notes, notes)
  end
end
