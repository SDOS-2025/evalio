defmodule EvalioAppWeb.SidePanel do
  use EvalioAppWeb, :live_component
  require Logger

  # Use aliases instead of imports to avoid ambiguity
  alias PetalComponents.Card
  alias PetalComponents.Button
  alias PetalComponents.Container

  alias EvalioApp.Reminder
  alias EvalioApp.Meeting
  alias EvalioAppWeb.MeetingTagMenu
  alias EvalioAppWeb.TagManager
  alias EvalioAppWeb.CalendarComponent
  alias EvalioAppWeb.ReminderContainer
  alias EvalioAppWeb.MeetingContainer
  alias EvalioAppWeb.NoteCard
  alias EvalioApp.Note
  alias EvalioAppWeb.SidePanel
  alias EvalioAppWeb.MeetingCard

  def render(assigns) do
    ~H"""
    <div>
      <div class="fixed right-0 top-0 h-screen w-1/3 bg-gray-200 dark:bg-gray-900 shadow-lg">
        <Container.container class="h-full px-4 py-4 flex flex-col">
          <!-- Existing Header Buttons -->
          <div class="w-full max-w-[90%] mx-auto flex justify-between mb-4">
            <button class="w-80 bg-transparent text-black dark:text-white border border-transparent outline-none shadow-none hover:border-gray-600 dark:hover:border-gray-400 focus:border-gray-600 dark:focus:border-gray-400 focus:ring-0 rounded-lg px-4 py-2 transition-colors duration-200">
              Profile
            </button>
            <button class="bg-transparent text-black dark:text-white border border-transparent outline-none shadow-none hover:border-gray-600 dark:hover:border-gray-400 focus:border-gray-600 dark:focus:border-gray-400 focus:ring-0 rounded-lg px-4 py-2 transition-colors duration-200">
              Stats
            </button>
          </div>

          <!-- Scrollable Content -->
          <div class="overflow-y-auto flex-grow space-y-4">
            <!-- Calendar Card -->
            <Card.card class="w-full max-w-[90%] mx-auto aspect-square bg-white dark:bg-gray-800 shadow-md rounded-2xl overflow-hidden p-4">
              <.live_component
                module={CalendarComponent}
                id="calendar"
                reminders={@reminders}
                meetings={@meetings}
              />
            </Card.card>

            <!-- Reminders Container -->
            <.live_component
              module={ReminderContainer}
              id="reminder-container"
              reminders={@reminders}
            />

            <!-- Meetings Container -->
            <.live_component
              module={MeetingContainer}
              id="meeting-container"
              meetings={@meetings}
            />
          </div>
        </Container.container>
      </div>
    </div>
    """
  end

  @impl true
  def mount(socket) do
    {:ok, assign(socket, reminders: [], meetings: [])}
  end

  @impl true
  def update(%{update_meeting_tag: {id, tag}} = assigns, socket) do
    # Find the meeting in the current list
    meeting = Enum.find(socket.assigns.meetings, &(&1.id == id))

    if meeting do
      # Update the meeting's tag
      updated_meeting = TagManager.update_meeting_tag(meeting, tag)

      # Update the meetings list
      updated_meetings = Enum.map(socket.assigns.meetings, fn m ->
        if m.id == id, do: updated_meeting, else: m
      end)

      # Sort the meetings
      sorted_meetings = sort_meetings(updated_meetings)

      {:ok, assign(socket, meetings: updated_meetings, sorted_meetings: sorted_meetings)}
    else
      {:ok, socket}
    end
  end

  def update(%{delete_meeting_id: id} = _assigns, socket) do
    updated_meetings = Enum.reject(socket.assigns.meetings, &(&1.id == id))
    sorted_meetings = sort_meetings(updated_meetings)

    {:ok, assign(socket,
      meetings: updated_meetings,
      sorted_meetings: sorted_meetings
    )}
  end

  def update(%{edit_meeting_id: id} = _assigns, socket) do
    # Find the meeting to edit
    meeting = Enum.find(socket.assigns.meetings, &(&1.id == id))

    socket =
      socket
      |> assign(:show_meeting_form, true)
      |> assign(:editing_meeting, meeting)

    {:ok, socket}
  end

  def update(assigns, socket) do
    reminders = assigns[:reminders] || []
    meetings = assigns[:meetings] || []

    # Log the data for debugging
    Logger.info("SidePanel update - Reminders: #{inspect(reminders)}")
    Logger.info("SidePanel update - Meetings: #{inspect(meetings)}")

    socket =
      socket
      |> assign(:reminders, reminders)
      |> assign(:meetings, meetings)

    {:ok, socket}
  end

  def handle_event("show_meeting_form", _params, socket) do
    {:noreply, assign(socket, show_meeting_form: true, editing_meeting: nil)}
  end

  def handle_event("edit_meeting", %{"id" => id}, socket) do
    meeting = Enum.find(socket.assigns.meetings, &(&1.id == id))

    socket =
      socket
      |> assign(:show_meeting_form, true)
      |> assign(:editing_meeting, meeting)

    {:noreply, socket}
  end

  def handle_event("delete_meeting", %{"id" => id}, socket) do
    updated_meetings = Enum.reject(socket.assigns.meetings, &(&1.id == id))
    sorted_meetings = sort_meetings(updated_meetings)
    {:noreply, assign(socket, meetings: updated_meetings, sorted_meetings: sorted_meetings)}
  end

  # Helper function to sort meetings
  defp sort_meetings(meetings) do
    Enum.sort_by(meetings, fn meeting ->
      {meeting.date, meeting.time}
    end)
  end
end
