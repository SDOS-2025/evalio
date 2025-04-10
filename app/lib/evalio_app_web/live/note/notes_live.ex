defmodule EvalioAppWeb.NotesLive do
  use EvalioAppWeb, :live_view
  import EvalioAppWeb.CoreComponents
  import PetalComponents
  require Logger

  alias EvalioAppWeb.NoteHelpers
  alias EvalioAppWeb.NoteFormComponent

  alias EvalioAppWeb.NoteContainer
  alias EvalioAppWeb.HomePage.SortMenu
  alias EvalioAppWeb.HomePage.FilterMenu
  alias EvalioAppWeb.HomePage.NewNote
  alias EvalioAppWeb.HomePage.SearchBar

  alias EvalioAppWeb.NoteCard
  alias EvalioApp.Note
  alias EvalioAppWeb.SidePanel

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket,
      show_form: false,
      notes: [],
      editing_id: nil,
      sort_by: "newest_first",
      tag_filter: "all",
      search_text: ""
    )}
  end

  @impl true
  def handle_event("toggle_form", _params, socket) do
    {:noreply, assign(socket, show_form: true, form: build_form())}
  end

  @impl true
  def handle_event("save_note", %{"title" => title, "content" => content}, socket) do
    # Extract special words from content (all words after # symbols)
    special_words = extract_special_word(content)

    case socket.assigns.editing_id do
      nil ->
        # Add new note
        note = Note.new(title, content, special_words)
        updated_socket = NoteHelpers.add_note(socket, note)
        {:noreply, assign(updated_socket, form: build_form())}

      id ->
        # Edit existing note
        # Find the existing note to preserve its tag, created_at, and pinned status
        existing_note = Enum.find(socket.assigns.notes, &(&1.id == id))

        # Create updated note while preserving the tag, created_at, and pinned status
        updated_note = %{
          Note.new(title, content, special_words) |
          id: id,
          tag: existing_note.tag,
          pinned: existing_note.pinned,
          created_at: existing_note.created_at
        }

        updated_socket = NoteHelpers.edit_note(socket, id, updated_note)
        updated_socket = assign(updated_socket,
          show_form: false,
          editing_id: nil,
          form: build_form()
        )
        {:noreply, updated_socket}
    end
  end

  # Extract all words that appear after a # symbol
  defp extract_special_word(content) do
    Regex.scan(~r/#(\w+)/, content)
    |> Enum.map(fn [_, word] -> word end)
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
  def handle_event("cancel_form", _params, socket) do
    {:noreply, assign(socket, show_form: false, editing_id: nil)}
  end

  @impl true
  defp build_form(note \\ %{"title" => "", "content" => ""}) do
    to_form(note)
  end

  @impl true
  def handle_event("delete_note", %{"id" => id}, socket) do
    Logger.info("Deleting note with ID: #{id}")
    {:noreply, NoteHelpers.delete_note(socket, id)}
  end

  @impl true
  def handle_info({:update_note_tag, id, tag}, socket) do
    updated_notes = Enum.map(socket.assigns.notes, fn note ->
      if note.id == id do
        Note.update_tag(note, tag)
      else
        note
      end
    end)

    {:noreply, assign(socket, notes: updated_notes)}
  end

  @impl true
  def handle_event("sort_notes", %{"sort" => sort_option}, socket) do
    {:noreply, assign(socket, sort_by: sort_option)}
  end

  @impl true
  def handle_event("filter_by_tag", %{"tag" => tag}, socket) do
    {:noreply, assign(socket, tag_filter: tag)}
  end

  @impl true
  def handle_info({:search_notes, search_text}, socket) do
    {:noreply, assign(socket, search_text: search_text)}
  end

  @impl true
  def handle_event("pin_note", %{"id" => id}, socket) do
    updated_notes = Enum.map(socket.assigns.notes, fn note ->
      if note.id == id do
        Note.toggle_pin(note)
      else
        note
      end
    end)

    {:noreply, assign(socket, notes: updated_notes)}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <div class="fixed top-[10px] left-[20px] mb-8 pt-8">
        <.live_component module={SearchBar} id="search-bar" />
      </div>

      <div>
        <.live_component
          module={NoteContainer}
          id="note-container"
          notes={filter_notes_by_search(@notes, @search_text)}
          sort_by={@sort_by}
          tag_filter={@tag_filter}
        />
      </div>

      <div class="relative">
        <div class="fixed top-[100px] left-5 w-2/3">
          <.live_component module={NewNote} id="new-note" />
        </div>

        <div class="flex gap-4 fixed top-[107px] left-[760px]">
          <.live_component module={SortMenu} id="sort-menu" />
        </div>
        <div class="flex gap-4 fixed top-[107px] left-[820px]">
          <.live_component module={FilterMenu} id="filter-menu" />
        </div>

        <.live_component module={SidePanel} id="side-panel" />

        <%= if @show_form do %>
          <div class="fixed inset-0 z-50">
            <.live_component
              module={NoteCard}
              id="note-form"
              form={@form}
              editing={true}
            />
          </div>
        <% end %>
      </div>
    </div>
    """
  end

  defp filter_notes_by_search(notes, ""), do: notes
  defp filter_notes_by_search(notes, search_text) do
    search_text = String.downcase(search_text)
    Enum.filter(notes, fn note ->
      String.contains?(String.downcase(note.title), search_text) ||
      String.contains?(String.downcase(note.content), search_text)
    end)
  end
end
