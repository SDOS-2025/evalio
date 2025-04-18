defmodule EvalioAppWeb.NoteContainer do
  use EvalioAppWeb, :live_component
  import PetalComponents

  alias EvalioAppWeb.NoteCard

  def render(assigns) do
    filtered_notes = if Map.has_key?(assigns, :notes) do
      filter_notes(assigns.notes, assigns.tag_filter || "all")
    else
      []
    end
    sorted_notes = sort_notes(filtered_notes, assigns.sort_by || "newest_first")
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
    filtered_notes = if Map.has_key?(assigns, :notes) do
      filter_notes(assigns.notes, assigns.tag_filter || "all")
    else
      []
    end
    sorted_notes = sort_notes(filtered_notes, assigns.sort_by || "newest_first")
    {:ok, assign(socket, assigns) |> assign(:sorted_notes, sorted_notes)}
  end

  def update(%{change_tag: {id, tag}} = assigns, socket) do
    require Logger
    Logger.info("NoteContainer: change_tag update received: id=#{id}, tag=#{tag}")

    # Forward the update to the NotesLive component
    send_update(EvalioAppWeb.NotesLive, id: "notes-live", update_note_tag: {id, tag})

    # Return the socket unchanged since we're just forwarding the update
    {:ok, socket}
  end

  defp filter_notes(notes, tag_filter) do
    case tag_filter do
      "all" -> notes
      tag -> Enum.filter(notes, & &1.tag == tag)
    end
  end

  defp sort_notes(notes, sort_option) do
    # First, separate pinned and unpinned notes
    {pinned, unpinned} = Enum.split_with(notes, & &1.pinned)

    # Sort each group according to the sort option
    sorted_pinned = sort_by_option(pinned, sort_option)
    sorted_unpinned = sort_by_option(unpinned, sort_option)

    # Combine the sorted groups, with pinned notes first
    sorted_pinned ++ sorted_unpinned
  end

  defp sort_by_option(notes, sort_option) do
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
