defmodule EvalioAppWeb.NotesLive do
  use EvalioAppWeb, :live_view
  import EvalioAppWeb.CoreComponents
  import PetalComponents

  alias EvalioAppWeb.NoteHelpers
  alias EvalioAppWeb.NoteComponent
  alias EvalioAppWeb.NoteFormComponent

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, show_form: false, title: "", content: "", notes: [])}
  end

  @impl true
  def handle_event("toggle_form", _params, socket) do
    {:noreply, assign(socket, show_form: !socket.assigns.show_form)}
  end

  @impl true
  def handle_event("save_note", %{"title" => title, "content" => content}, socket) do
    IO.inspect(%{title: title, content: content}, label: "Received Note Input")
    updated_socket = NoteHelpers.add_note(socket, title, content)
    IO.inspect(updated_socket.assigns.notes, label: "Updated Notes List")
    {:noreply, updated_socket}
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
      <.live_component module={NoteFormComponent} id="note-form" title={@title} content={@content} />
    <% end %>

    <div class="mt-8 grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-4">
      <%= for {note, index} <- Enum.with_index(@notes) do %>
        <.live_component module={NoteComponent} id={"note-#{index}"} note={note} index={index} />
      <% end %>
    </div>
    """
  end
end
