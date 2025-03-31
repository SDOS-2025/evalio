defmodule EvalioAppWeb.NotesLive do
  use EvalioAppWeb, :live_view
  import PetalComponents

  alias EvalioAppWeb.NoteHelpers
  alias EvalioAppWeb.NoteComponent
  alias EvalioAppWeb.NoteFormComponent
  alias EvalioAppWeb.NoteCard
  alias EvalioAppWeb.SidePanel
  alias EvalioAppWeb.ReminderFormComponent

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, show_form: false, form_type: nil, title: "", content: "", notes: [], editing_index: nil)}
  end

  @impl true
  def handle_event("toggle_form", _params, socket) do
    {:noreply, assign(socket, show_form: !socket.assigns.show_form, form_type: "note", editing_index: nil)}
  end

  @impl true
  def handle_event("save_note", %{"title" => title, "content" => content}, socket) do
    case socket.assigns.editing_index do
      nil ->
        # Add new note
        updated_socket = NoteHelpers.add_note(socket, title, content)
        {:noreply, updated_socket}

      index ->
        # Edit existing note
        updated_socket = NoteHelpers.edit_note(socket, index, title, content)
        {:noreply, assign(updated_socket, editing_index: nil, show_form: false)}
    end
  end

  @impl true
  def handle_event("edit_note", %{"index" => index}, socket) do
    # Find the note to edit
    note = Enum.at(socket.assigns.notes, String.to_integer(index))

    {:noreply,
     assign(socket,
       show_form: true,
       editing_index: index,
       title: note.title,
       content: note.content
     )}
  end

  @impl true
  def handle_event("delete_note", %{"index" => index}, socket) do
    {:noreply, NoteHelpers.delete_note(socket, index)}
  end

  def handle_event("show_reminder_form", _params, socket) do
    {:noreply, assign(socket, show_form: true, form_type: "reminder")}
  end

  def handle_event("show_meeting_form", _params, socket) do
    {:noreply, assign(socket, show_form: true, form_type: "meeting")}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div class="flex justify-start">
      <.button color="primary" label="New Note" phx-click="toggle_form" />
    </div>

    <%= if @show_form do %>
      <div class="fixed inset-0 flex items-center justify-center z-50">
        <div class="absolute inset-0 bg-black bg-opacity-50"></div> <!-- Background Overlay -->
        <div class="relative z-50 p-4 bg-white rounded-lg shadow-lg w-96">
          <%= case @form_type do %>
            <% "note" -> %>
              <.live_component
                module={NoteFormComponent}
                id="note-form"
                title={@title}
                content={@content}
                editing_index={@editing_index}
              />
            <% "reminder" -> %>
              <.live_component
                module={ReminderFormComponent}
                id="reminder-form"
              />
            <% "meeting" -> %>
              <.live_component
                module={MeetingFormComponent}
                id="meeting-form"
              />
          <% end %>
        </div>
      </div>
    <% end %>

    <div class="mt-8 grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-4">
      <%= for {note, index} <- Enum.with_index(@notes) do %>
        <.live_component
          module={NoteComponent}
          id={"note-#{index}"}
          note={note}
          index={index}
          phx-click="edit_note"
          phx-value-index={index}
        />
      <% end %>
    </div>

    <div>
      <.live_component module={SidePanel} id="side-panel" />
    </div>
    """
  end
end
