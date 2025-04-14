defmodule EvalioAppWeb.SidePanel do
  use EvalioAppWeb, :live_component

  # Use aliases instead of imports to avoid ambiguity
  alias PetalComponents.Card
  alias PetalComponents.Button
  alias PetalComponents.Container

  alias EvalioApp.Reminder
  alias EvalioApp.Meeting
  alias EvalioAppWeb.MeetingTagMenu
  alias EvalioAppWeb.TagManager
  alias EvalioAppWeb.CalendarComponent
  alias EvalioAppWeb.ReminderCard
  alias EvalioAppWeb.NoteCard
  alias EvalioApp.Note
  alias EvalioAppWeb.SidePanel
  alias EvalioAppWeb.ReminderFormComponent
  alias EvalioAppWeb.MeetingCard

  def render(assigns) do
    ~H"""
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
          <!-- Reminders Card -->
          <Card.card class="w-full max-w-[90%] mx-auto aspect-square bg-white dark:bg-gray-800 shadow-md rounded-2xl relative p-4 flex flex-col">
            <div class="flex justify-between items-center">
              <h4 class="text-xl font-bold text-gray-800 dark:text-gray-200">Reminders</h4>
              <button phx-click="show_reminder_form" phx-target={@myself}>
                <span class="text-2xl text-gray-600 dark:text-gray-300">+</span>
              </button>
            </div>

            <div class="mt-4 flex-grow w-full max-h-[310px] overflow-y-auto bg-transparent rounded-lg px-0 py-2 space-y-2 transition-all duration-300 ease-in-out">
              <%= for {reminder, index} <- Enum.with_index(@sorted_reminders) do %>
                <div class="transition-all duration-300 ease-in-out">
                  <.live_component
                    module={EvalioAppWeb.ReminderCard}
                    id={"reminder-#{reminder.id}"}
                    reminder={reminder}
                    on_delete="delete_reminder"
                    on_edit="edit_reminder"
                  />
                </div>
              <% end %>
            </div>
          </Card.card>

          <!-- Meetings Card -->
          <Card.card class="w-full max-w-[90%] mx-auto aspect-square bg-white dark:bg-gray-800 shadow-md rounded-2xl relative p-4 flex flex-col">
            <div class="flex justify-between items-center">
              <h4 class="text-xl font-bold text-gray-800 dark:text-gray-200">Meetings</h4>
              <button phx-click="show_meeting_form" phx-target={@myself}>
                <span class="text-2xl text-gray-600 dark:text-gray-300">+</span>
              </button>
            </div>

            <div class="mt-4 flex-grow w-full max-h-[310px] overflow-y-auto bg-transparent rounded-lg px-0 py-2 space-y-2">
              <%= for {meeting, index} <- Enum.with_index(@sorted_meetings) do %>
                <.live_component
                  module={MeetingCard}
                  id={"meeting-#{meeting.id}"}
                  meeting={meeting}
                  on_edit="edit_meeting"
                />
              <% end %>
            </div>
          </Card.card>

        </div>

        <!-- Popups for Forms -->
        <%= if @show_meeting_form do %>
          <div class="fixed inset-0 flex items-center justify-center z-50">
            <div class="absolute inset-0 bg-black/30 backdrop-blur-lg"></div>
            <div class="relative z-50">
              <.live_component module={EvalioAppWeb.MeetingFormComponent} id="meeting_form" myself={@myself} meeting={@editing_meeting} />
            </div>
          </div>
        <% end %>

        <%= if @show_reminder_form do %>
          <div class="fixed inset-0 flex items-center justify-center z-50">
            <div class="absolute inset-0 bg-black/30 backdrop-blur-lg"></div>
            <div class="relative z-50">
              <.live_component module={EvalioAppWeb.ReminderFormComponent} id="reminder_form" myself={@myself} reminder={@editing_reminder} />
            </div>
          </div>
        <% end %>

      </Container.container>
    </div>
    """
  end

  @impl true
  def update(%{update_reminder_tag: {id, tag}} = assigns, socket) do
    # Find the reminder in the current list
    reminder = Enum.find(socket.assigns.reminders, &(&1.id == id))

    if reminder do
      # Update the reminder's tag
      updated_reminder = TagManager.update_reminder_tag(reminder, tag)

      # Update the reminders list
      updated_reminders = Enum.map(socket.assigns.reminders, fn r ->
        if r.id == id, do: updated_reminder, else: r
      end)

      # Sort the reminders
      sorted_reminders = sort_reminders(updated_reminders)

      {:ok, assign(socket, reminders: updated_reminders, sorted_reminders: sorted_reminders)}
    else
      {:ok, socket}
    end
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

  @impl true
  def update(%{delete_reminder_id: id} = _assigns, socket) do
    updated_reminders = Enum.reject(socket.assigns.reminders, &(&1.id == id))
    sorted_reminders = sort_reminders(updated_reminders)

    {:ok, assign(socket,
      reminders: updated_reminders,
      sorted_reminders: sorted_reminders
    )}
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

    # Sort reminders and meetings
    sorted_reminders = sort_reminders(reminders)
    sorted_meetings = sort_meetings(meetings)

    socket =
      socket
      |> assign(:reminders, reminders)
      |> assign(:meetings, meetings)
      |> assign(:sorted_reminders, sorted_reminders)
      |> assign(:sorted_meetings, sorted_meetings)
      |> assign(:show_reminder_form, assigns[:show_reminder_form] || false)
      |> assign(:show_meeting_form, assigns[:show_meeting_form] || false)
      |> assign_new(:editing_reminder, fn -> nil end)
      |> assign_new(:editing_meeting, fn -> nil end)

    {:ok, socket}
  end

  # Existing handle_events...

  def handle_event("edit_reminder", %{"id" => id}, socket) do
    reminder = Enum.find(socket.assigns.reminders, &(&1.id == id))

    socket =
      socket
      |> assign(:show_reminder_form, true)
      |> assign(:editing_reminder, reminder)

    {:noreply, socket}
  end

  def handle_event("delete_reminder", %{"id" => id}, socket) do
    updated_reminders = Enum.reject(socket.assigns.reminders, &(&1.id == id))
    sorted_reminders = sort_reminders(updated_reminders)
    {:noreply, assign(socket, reminders: updated_reminders, sorted_reminders: sorted_reminders)}
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

  def handle_event("show_reminder_form", _, socket) do
    # Reset editing state when showing the form for a new reminder
    socket =
      socket
      |> assign(:show_reminder_form, true)
      |> assign(:editing_reminder, nil)

    {:noreply, socket}
  end

  def handle_event("hide_reminder_form", _, socket) do
    {:noreply, assign(socket, :show_reminder_form, false)}
  end

  def handle_event("save_reminder", %{"date" => date, "title" => title, "time" => time}, socket) do
    if date == "" or title == "" or time == "" do
      {:noreply, socket}
    else
      updated_reminders =
        case socket.assigns[:editing_reminder] do
          nil ->
            # Create new reminder
            [Reminder.new(title, date, time) | socket.assigns.reminders]
          reminder ->
            # Update existing reminder while preserving the tag
            Enum.map(socket.assigns.reminders, fn r ->
              if r.id == reminder.id do
                updated = Reminder.update(r, title, date, time)
                # Preserve the tag
                %{updated | tag: r.tag}
              else
                r
              end
            end)
        end

      # Sort the reminders
      sorted_reminders = sort_reminders(updated_reminders)

      socket =
        socket
        |> assign(:reminders, updated_reminders)
        |> assign(:sorted_reminders, sorted_reminders)
        |> assign(:show_reminder_form, false)
        |> assign(:editing_reminder, nil)

      {:noreply, socket}
    end
  end

  def handle_event("save_meeting", %{"date" => date, "time" => time, "title" => title, "link" => link}, socket) do
    if date == "" or time == "" or title == "" or link == "" do
      {:noreply, socket}
    else
      updated_meetings =
        case socket.assigns[:editing_meeting] do
          nil ->
            # Create new meeting
            [Meeting.new(title, date, time, link) | socket.assigns.meetings]
          meeting ->
            # Update existing meeting while preserving the tag
            Enum.map(socket.assigns.meetings, fn m ->
              if m.id == meeting.id do
                updated = Meeting.update(m, title, date, time, link)
                # Preserve the tag
                %{updated | tag: m.tag}
              else
                m
              end
            end)
        end

      # Sort the meetings
      sorted_meetings = sort_meetings(updated_meetings)

      socket =
        socket
        |> assign(:meetings, updated_meetings)
        |> assign(:sorted_meetings, sorted_meetings)
        |> assign(:show_meeting_form, false)
        |> assign(:editing_meeting, nil)

      {:noreply, socket}
    end
  end


  def handle_event("show_meeting_form", _, socket) do
    # Reset editing state when showing the form for a new meeting
    socket =
      socket
      |> assign(:show_meeting_form, true)
      |> assign(:editing_meeting, nil)

    {:noreply, socket}
  end

  def handle_event("hide_meeting_form", _, socket) do
    {:noreply, assign(socket, :show_meeting_form, false)}
  end

  defp format_date(date_string) do
    case Date.from_iso8601(date_string) do
      {:ok, date} ->
        "#{String.pad_leading("#{date.day}", 2, "0")}-#{String.pad_leading("#{date.month}", 2, "0")}-#{date.year}"
      _ ->
        date_string
    end
  end

  # Sort reminders by date and time (most recent first)
  defp sort_reminders(reminders) do
    Enum.sort_by(reminders, fn reminder ->
      {reminder.date, reminder.time}
    end, :asc)
  end

  # Sort meetings by date and time (most recent first)
  defp sort_meetings(meetings) do
    Enum.sort_by(meetings, fn meeting ->
      {meeting.date, meeting.time}
    end, :asc)
  end

  def handle_info({:update_reminder_tag, id, tag}, socket) do
    # Find and update the reminder
    updated_reminders = Enum.map(socket.assigns.reminders, fn reminder ->
      if reminder.id == id do
        Map.put(reminder, :tag, tag)
      else
        reminder
      end
    end)

    # Sort the reminders
    sorted_reminders = sort_reminders(updated_reminders)

    {:noreply, assign(socket,
      reminders: updated_reminders,
      sorted_reminders: sorted_reminders
    )}
  end

  def handle_info({:delete_reminder, id}, socket) do
    updated_reminders = Enum.reject(socket.assigns.reminders, &(&1.id == id))
    sorted_reminders = sort_reminders(updated_reminders)

    {:noreply, assign(socket,
      reminders: updated_reminders,
      sorted_reminders: sorted_reminders
    )}
  end
end
