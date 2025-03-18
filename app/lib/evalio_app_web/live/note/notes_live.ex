defmodule EvalioAppWeb.NotesLive do
  use EvalioAppWeb, :live_view
  import EvalioAppWeb.CoreComponents
  import PetalComponents

  alias EvalioAppWeb.NoteHelpers
  alias EvalioAppWeb.NoteFormComponent
  alias EvalioAppWeb.NoteContainer

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, show_form: false, title: "", content: "", notes: [], editing_index: nil)}
  end

  @impl true
  def handle_event("toggle_form", _params, socket) do
    {:noreply, assign(socket, show_form: !socket.assigns.show_form, editing_index: nil)}
  end

  @impl true
  def handle_event("save_note", %{"title" => title, "content" => content}, socket) do
    case socket.assigns.editing_index do
      nil ->
        id = System.unique_integer([:positive])  # Generate a unique ID
        new_note = %{id: id, title: title, content: content}
        updated_notes = [new_note | socket.assigns.notes]
        {:noreply, assign(socket, notes: updated_notes, show_form: false)}

      index ->
        updated_notes =
          Enum.with_index(socket.assigns.notes)
          |> Enum.map(fn {note, idx} ->
            if idx == String.to_integer(index), do: %{note | title: title, content: content}, else: note
          end)

        {:noreply, assign(socket, notes: updated_notes, editing_index: nil, show_form: false)}
    end
  end

  @impl true
  def handle_event("edit_note", %{"index" => index}, socket) do
    note = Enum.at(socket.assigns.notes, String.to_integer(index))
    {:noreply, assign(socket, show_form: true, editing_index: index, title: note.title, content: note.content)}
  end

  @impl true
  def handle_event("delete_note", %{"index" => index}, socket) do
    updated_notes = List.delete_at(socket.assigns.notes, String.to_integer(index))
    {:noreply, assign(socket, notes: updated_notes)}
  end

  @impl true
  def handle_info({:delete_note, index}, socket) do
    updated_notes = Enum.reject(socket.assigns.notes, fn note -> note.id == String.to_integer(index) end)
    {:noreply, assign(socket, notes: updated_notes)}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div class="flex justify-start">
      <.button color="primary" label="New Note" phx-click="toggle_form" />
    </div>

    <%= if @show_form do %>
      <.live_component
        module={NoteFormComponent}
        id="note-form"
        title={@title}
        content={@content}
        editing_index={@editing_index}
      />
    <% end %>

    <.live_component module={NoteContainer} id="note-container" notes={@notes} />
    """
  end
end
