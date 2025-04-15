defmodule EvalioAppWeb.NotesLive do
  use EvalioAppWeb, :live_view
  import EvalioAppWeb.CoreComponents
  import PetalComponents
  require Logger

  alias EvalioAppWeb.NoteHelpers
  alias EvalioAppWeb.NoteFormComponent
  alias EvalioAppWeb.Components.HomePage.Topbar

  alias EvalioAppWeb.NoteContainer
  alias EvalioAppWeb.HomePage.SortMenu
  alias EvalioAppWeb.HomePage.FilterMenu
  alias EvalioAppWeb.HomePage.NewNote
  alias EvalioAppWeb.HomePage.SearchBar

  alias EvalioAppWeb.NoteCard
  alias EvalioApp.Note
  alias EvalioAppWeb.SidePanel
  alias EvalioAppWeb.ReminderFormComponent

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket,
      show_form: false,
      form_type: nil,
      # title: "", content: "",
      notes: [],
      editing_id: nil,
      sort_by: "newest_first",
      tag_filter: "all",
      search_text: "",
      editing_index: nil,
      reading_note: nil
    )}
  end

  @impl true
  def handle_event("toggle_form", _params, socket) do
    {:noreply, assign(socket, show_form: true, form_type: "note", form: build_form())}
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

  def handle_event("show_reminder_form", _params, socket) do
    {:noreply, assign(socket, show_form: true, form_type: "reminder")}
  end

  def handle_event("show_meeting_form", _params, socket) do
    {:noreply, assign(socket, show_form: true, form_type: "meeting")}
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
  def handle_info({:update_reminder_tag, id, tag}, socket) do
    # Forward the message to the SidePanel component
    send_update(EvalioAppWeb.SidePanel, id: "side-panel", update_reminder_tag: {id, tag})
    {:noreply, socket}
  end

  @impl true
  def handle_info({:update_meeting_tag, id, tag}, socket) do
    # Forward the message to the SidePanel component
    send_update(EvalioAppWeb.SidePanel, id: "side-panel", update_meeting_tag: {id, tag})
    {:noreply, socket}
  end

  @impl true
  def handle_info({:search_notes, search_text}, socket) do
    {:noreply, assign(socket, search_text: search_text)}
  end

  @impl true
  def handle_info({:finish_delete, id}, socket) do
    # Forward the message to the SidePanel component
    send_update(EvalioAppWeb.SidePanel, id: "side-panel", delete_reminder_id: id)
    {:noreply, socket}
  end

  @impl true
  def handle_info({:finish_delete_meeting, id}, socket) do
    # Forward the message to the SidePanel component
    send_update(EvalioAppWeb.SidePanel, id: "side-panel", delete_meeting_id: id)
    {:noreply, socket}
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
  def handle_event("navigate", %{"to" => path}, socket) do
    {:noreply, push_navigate(socket, to: path)}
  end

  @impl true
  def handle_event("logout", _params, socket) do
    {:noreply, push_navigate(socket, to: ~p"/login")}
  end

  @impl true
  def handle_info({:toggle_read_mode, note}, socket) do
    {:noreply, assign(socket, reading_note: note)}
  end

  @impl true
  def handle_info({:close_read_mode}, socket) do
    {:noreply, assign(socket, reading_note: nil)}
  end

  @impl true
  def render(assigns) do
    ~H"""

    <div>
      <div class="fixed top-0 left-0 right-0 z-40">
        <Topbar.topbar />
      </div>

      <div class="pt-16">
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
          <div class="fixed top-[100px] left-5 w-2/3 z-30">
            <.live_component module={NewNote} id="new-note" />
          </div>

          <div class="fixed top-[107px] left-[760px] flex gap-4 z-30">
            <.live_component module={SortMenu} id="sort-menu" />
            <.live_component module={FilterMenu} id="filter-menu" />
          </div>

          <div class="z-30">
            <.live_component module={SidePanel} id="side-panel" />
          </div>
        </div>

        <%= if @show_form do %>
          <div class="fixed inset-0 z-[200]">
            <div class="fixed inset-0 bg-black/30 backdrop-blur-lg"></div>
            <div class="fixed inset-0 flex items-center justify-center">
              <div class="relative z-[201]">
                <%= case @form_type do %>
                  <% "note" -> %>
                    <.live_component
                      module={NoteCard}
                      id="note-form"
                      form={@form}
                      editing={true}
                    />
                  <% "reminder" -> %>
                    <.live_component
                      module={ReminderFormComponent}
                      id="reminder-form"
                      myself={@myself}
                      reminder={@editing_reminder}
                    />
                  <% "meeting" -> %>
                    <.live_component
                      module={MeetingFormComponent}
                      id="meeting-form"
                      myself={@myself}
                      meeting={@editing_meeting}
                    />
                <% end %>
              </div>
            </div>
          </div>
        <% end %>

        <%= if @reading_note do %>
          <div class="fixed inset-0 z-[200]">
            <div class="fixed inset-0 bg-black/30 backdrop-blur-lg"></div>
            <div class="fixed inset-0 flex items-center justify-center">
              <div class="relative z-[201]">
                <div class="bg-white rounded-lg shadow-lg w-[800px] h-[600px]">
                  <div class="h-full flex flex-col">
                    <div class="p-6 border-b border-gray-200">
                      <div class="flex justify-between items-center">
                        <h3 class="font-bold text-2xl"><%= @reading_note.title %></h3>
                        <button phx-click="close_read_mode" class="text-gray-500 hover:text-gray-700">
                          <svg xmlns="http://www.w3.org/2000/svg" class="h-6 w-6" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12" />
                          </svg>
                        </button>
                      </div>
                    </div>
                    <div class="flex-1 overflow-y-auto p-6">
                      <div class="text-gray-700 text-lg">
                        <%= for line <- String.split(@reading_note.content, "\n") do %>
                          <div class="whitespace-pre-wrap"><%= line %></div>
                        <% end %>
                      </div>
                    </div>
                  </div>
                </div>
              </div>
            </div>
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

  @impl true
  def handle_event("close_read_mode", _params, socket) do
    {:noreply, assign(socket, reading_note: nil)}
  end
end
