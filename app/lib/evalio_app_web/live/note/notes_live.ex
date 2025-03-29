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
    {:ok, assign(socket, show_form: false, notes: [], editing_index: nil)}
  end

  @impl true
  def handle_event("toggle_form", _params, socket) do
    {:noreply, assign(socket, show_form: true, form: build_form())}
  end

  # @impl true
  # def handle_event("toggle_edit", _params, socket) do
  #   {:noreply, assign(socket, editing: !socket.assigns.editing)}
  # end

  @impl true
  def handle_event("save_note", %{"title" => title, "content" => content}, socket) do
    note = Note.new(title, content)

    case socket.assigns.editing_index do
      nil ->
        # Add new note
        updated_socket = NoteHelpers.add_note(socket, note)
        {:noreply, assign(updated_socket, form: build_form())}

      index ->
        # Edit existing note
        updated_socket = NoteHelpers.edit_note(socket, index, note)
        updated_socket = assign(updated_socket,
          show_form: false,
          editing_index: nil,
          form: build_form()
        )
        {:noreply, updated_socket}
    end
  end



  @impl true
  def handle_event("edit_note", %{"index" => index}, socket) do
    # Find the note to edit
    note = Enum.at(socket.assigns.notes, String.to_integer(index))

    # Build form with existing note data
    form = build_form(%{"title" => note.title, "content" => note.content})

    {:noreply,
     assign(socket,
       show_form: true,
       editing: true,
       editing_index: index,
       form: form
     )}
  end

  @impl true
  defp build_form(note \\ %{"title" => "", "content" => ""}) do
    to_form(note)
  end

  @impl true
  def handle_event("delete_note", %{"index" => index}, socket) do
    {:noreply, NoteHelpers.delete_note(socket, index)}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div class="flex justify-start">
      <.button color="primary" label="New Note" phx-click="toggle_form" />
    </div>

    <%= if @show_form do %>
      <.live_component
        module={NoteCard}
        id="note-form"
        form={@form}
        editing_index={@editing_index}
        editing={true}
      />
    <% end %>

    <div class="mt-8 grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-4">
    <%= for {note, index} <- Enum.with_index(@notes) do %>
      <.live_component
        module={NoteCard}
        id={"note-#{index}"}
        note={note}
        index={index}
        editing={note.editing}
      />
    <% end %>

    </div>

    <div>
        <.live_component module={SidePanel} id="side-panel" />
    </div>
    """
  end
end
