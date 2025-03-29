defmodule EvalioAppWeb.NotesLive do
  use EvalioAppWeb, :live_view
  import EvalioAppWeb.CoreComponents
  import PetalComponents

  alias EvalioAppWeb.NoteHelpers
  alias EvalioAppWeb.NoteComponent
  alias EvalioAppWeb.NoteFormComponent
  alias EvalioAppWeb.NoteCard
  alias EvalioApp.Note
  alias EvalioAppWeb.SidePanel

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, show_form: false, notes: [], editing_id: nil)}
  end

  @impl true
  def handle_event("toggle_form", _params, socket) do
    {:noreply, assign(socket, show_form: true, form: build_form())}
  end

  @impl true
  def handle_event("save_note", %{"title" => title, "content" => content}, socket) do
    note = Note.new(title, content)

    case socket.assigns.editing_id do
      nil ->
        # Add new note
        updated_socket = NoteHelpers.add_note(socket, note)
        {:noreply, assign(updated_socket, form: build_form())}

      id ->
        # Edit existing note
        updated_socket = NoteHelpers.edit_note(socket, id, note)
        updated_socket = assign(updated_socket,
          show_form: false,
          editing_id: nil,
          form: build_form()
        )
        {:noreply, updated_socket}
    end
  end

  @impl true
  def handle_event("edit_note", %{"id" => id}, socket) do
    # Find the note to edit
    note = Enum.find(socket.assigns.notes, &(&1.id == id))

    # Build form with existing note data
    form = build_form(%{"title" => note.title, "content" => note.content})

    {:noreply,
     assign(socket,
       show_form: true,
       editing: true,
       editing_id: id,
       form: form
     )}
  end

  @impl true
  defp build_form(note \\ %{"title" => "", "content" => ""}) do
    to_form(note)
  end

  @impl true
  def handle_event("delete_note", %{"id" => id}, socket) do
    {:noreply, NoteHelpers.delete_note(socket, id)}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div class="relative">
      <div class="flex justify-start">
        <.button color="primary" label="New Note" phx-click="toggle_form" />
      </div>

      <div class="mt-8 grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-4">
      <%= for note <- @notes do %>
        <.live_component
          module={NoteCard}
          id={"note-#{note.id}"}
          note={note}
          editing={note.editing}
        />
      <% end %>
      </div>

      <.live_component
        module={EvalioAppWeb.SidePanel}
        id="side-panel"
      />

      <%= if @show_form do %>
        <div class="fixed inset-0 z-50">
          <.live_component
            module={NoteCard}
            id="note-form"
            form={@form}
            editing_id={@editing_id}
            editing={true}
          />
        </div>
      <% end %>
    </div>
    """
  end
end
