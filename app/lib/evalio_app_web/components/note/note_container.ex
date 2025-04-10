defmodule EvalioAppWeb.NoteContainer do
  use EvalioAppWeb, :live_component
  import PetalComponents

  alias EvalioAppWeb.NoteCard

  def render(assigns) do
    sorted_notes = sort_notes(assigns.notes, assigns.sort_by || "newest_first")
    assigns = assign(assigns, :sorted_notes, sorted_notes)

    ~H"""
    <div class="fixed top-[200px] left-0 w-2/3 h-[calc(100vh-170px)] overflow-y-auto">
      <div class="grid grid-cols-3 gap-6 p-6">
        <%= for note <- @sorted_notes do %>
          <.live_component module={NoteCard} id={"note-#{note.id}"} note={note} editing={false} />
        <% end %>
      </div>
    </div>
    """
  end

  def update(assigns, socket) do
    sorted_notes = sort_notes(assigns.notes, assigns.sort_by || "newest_first")
    {:ok, assign(socket, assigns) |> assign(:sorted_notes, sorted_notes)}
  end

  defp sort_notes(notes, sort_option) do
    case sort_option do
      "newest_first" ->
        Enum.sort_by(notes, & &1.created_at, {:desc, DateTime})

      "oldest_first" ->
        Enum.sort_by(notes, & &1.created_at, {:asc, DateTime})

      "last_edited" ->
        Enum.sort_by(notes, & &1.last_edited_at, {:desc, DateTime})

      "title_asc" ->
        Enum.sort_by(notes, & &1.title, :asc)

      "title_desc" ->
        Enum.sort_by(notes, & &1.title, :desc)

      _ ->
        # Default to newest first
        Enum.sort_by(notes, & &1.created_at, {:desc, DateTime})
    end
  end
end
