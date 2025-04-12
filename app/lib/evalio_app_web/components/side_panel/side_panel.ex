defmodule EvalioAppWeb.SidePanel do
  use EvalioAppWeb, :live_component
  import PetalComponents

  def render(assigns) do
    ~H"""
    <div class="fixed right-0 top-0 h-screen w-1/3 bg-gray-200 dark:bg-gray-900 shadow-lg">
      <.container class="h-full px-4 py-4 flex flex-col">

        <!-- Existing Header Buttons -->
        <div class="w-full max-w-[90%] mx-auto flex justify-between mb-4">
          <.button class="w-80 bg-transparent text-black dark:text-white border-none outline-none shadow-none">
            Profile
          </.button>
          <.button class="bg-green-500 dark:bg-green-700 text-white px-4 py-2 rounded-lg">
            Stats
          </.button>
        </div>

        <!-- Scrollable Content -->
        <div class="overflow-y-auto flex-grow space-y-4">
          <!-- Calendar Card -->
          <%!-- <.card class="w-full max-w-[90%] mx-auto aspect-square bg-white dark:bg-gray-800 shadow-md rounded-2xl flex items-center justify-center">
            <h3 class="text-lg font-semibold text-gray-900 dark:text-gray-100">Calendar</h3>
          </.card> --%>
          <.card class="w-full max-w-[90%] mx-auto aspect-square bg-white dark:bg-gray-800 shadow-md rounded-2xl overflow-hidden p-0">
            <img src="/images/calender.png" alt="Calendar" class="w-full h-full object-cover" />
          </.card>


          <!-- Reminders Card -->
          <.card class="w-full max-w-[90%] mx-auto aspect-square bg-white dark:bg-gray-800 shadow-md rounded-2xl relative p-4 flex flex-col">
            <div class="flex justify-between items-center">
              <h4 class="text-xl font-bold text-gray-800 dark:text-gray-200">Reminders</h4>
              <button phx-click="show_reminder_form" phx-target={@myself}>
                <span class="text-2xl text-gray-600 dark:text-gray-300">+</span>
              </button>
            </div>

            <div class="mt-4 flex-grow w-full max-h-[310px] overflow-y-auto bg-gray-100 dark:bg-gray-700 rounded-lg p-2 space-y-2">
              <%= for {reminder, index} <- Enum.with_index(@reminders) do %>
                <.card class="w-[95%] mx-auto h-20 bg-gray-300 dark:bg-gray-600 shadow-md rounded-lg p-3 flex justify-between items-center">
                  <p class="text-sm text-gray-900 dark:text-gray-100">
                    <%= reminder.title %> - <%= reminder.date %> <%= reminder.time %>
                  </p>
                  <div class="ml-auto flex gap-2">
                    <button phx-click="edit_reminder" phx-value-index={index} phx-target={@myself} class="text-blue-500">Edit</button>
                    <button phx-click="delete_reminder" phx-value-index={index} phx-target={@myself} class="text-red-500">Delete</button>
                  </div>
                </.card>
              <% end %>
            </div>
          </.card>

          <!-- Meetings Card -->
          <.card class="w-full max-w-[90%] mx-auto aspect-square bg-white dark:bg-gray-800 shadow-md rounded-2xl relative p-4 flex flex-col">
            <div class="flex justify-between items-center">
              <h4 class="text-xl font-bold text-gray-800 dark:text-gray-200">Meetings</h4>
              <button phx-click="show_meeting_form" phx-target={@myself}>
                <span class="text-2xl text-gray-600 dark:text-gray-300">+</span>
              </button>
            </div>

            <div class="mt-4 flex-grow w-full max-h-[310px] overflow-y-auto bg-gray-100 dark:bg-gray-700 rounded-lg p-2 space-y-2">
              <%= for {meeting, index} <- Enum.with_index(@meetings) do %>
                <.card class="w-[95%] mx-auto h-20 bg-gray-300 dark:bg-gray-600 shadow-md rounded-lg p-3 flex justify-between items-center">
                  <div>
                    <p class="text-sm text-gray-900 dark:text-gray-100">
                      <%= meeting.title %> - <%= meeting.date %> <%= meeting.time %>
                    </p>
                    <a href={meeting.link} target="_blank" class="text-blue-500 underline">JoinMeeting</a>
                  </div>
                  <div class="ml-auto flex gap-2">
                    <button phx-click="edit_meeting" phx-value-index={index} phx-target={@myself} class="text-blue-500">Edit</button>
                    <button phx-click="delete_meeting" phx-value-index={index} phx-target={@myself} class="text-red-500">Delete</button>
                  </div>
                </.card>
              <% end %>
            </div>
          </.card>

        </div>

        <!-- Popups for Forms -->
        <%= if @show_meeting_form do %>
          <div class="fixed inset-0 flex items-center justify-center bg-black bg-opacity-50">
            <.live_component module={EvalioAppWeb.MeetingFormComponent} id="meeting_form" myself={@myself} meeting={@editing_meeting} />
          </div>
        <% end %>

        <%= if @show_reminder_form do %>
          <div class="fixed inset-0 flex items-center justify-center bg-black bg-opacity-50">
            <.live_component module={EvalioAppWeb.ReminderFormComponent} id="reminder_form" myself={@myself} reminder={@editing_reminder} />
          </div>
        <% end %>

      </.container>
    </div>
    """
  end

  def update(assigns, socket) do
    socket =
      socket
      |> assign(:reminders, assigns[:reminders] || [])
      |> assign(:meetings, assigns[:meetings] || [])
      |> assign(:show_reminder_form, assigns[:show_reminder_form] || false)
      |> assign(:show_meeting_form, assigns[:show_meeting_form] || false)
      |> assign_new(:editing_reminder, fn -> nil end)
      |> assign_new(:editing_meeting, fn -> nil end)

    {:ok, socket}
  end
  # Existing handle_events...

  def handle_event("edit_reminder", %{"index" => index}, socket) do
    reminder = Enum.at(socket.assigns.reminders, String.to_integer(index))

    socket =
      socket
      |> assign(:show_reminder_form, true)
      |> assign(:editing_reminder, reminder)
      |> assign(:editing_reminder_index, String.to_integer(index))

    {:noreply, socket}
  end

  def handle_event("delete_reminder", %{"index" => index}, socket) do
    updated_reminders = List.delete_at(socket.assigns.reminders, String.to_integer(index))
    {:noreply, assign(socket, :reminders, updated_reminders)}
  end

  def handle_event("edit_meeting", %{"index" => index}, socket) do
    meeting = Enum.at(socket.assigns.meetings, String.to_integer(index))

    socket =
      socket
      |> assign(:show_meeting_form, true)
      |> assign(:editing_meeting, meeting)
      |> assign(:editing_meeting_index, String.to_integer(index))

    {:noreply, socket}
  end

  def handle_event("delete_meeting", %{"index" => index}, socket) do
    updated_meetings = List.delete_at(socket.assigns.meetings, String.to_integer(index))
    {:noreply, assign(socket, :meetings, updated_meetings)}
  end

  def handle_event("show_reminder_form", _, socket) do
    {:noreply, assign(socket, :show_reminder_form, true)}
  end

  def handle_event("hide_reminder_form", _, socket) do
    {:noreply, assign(socket, :show_reminder_form, false)}
  end

  def handle_event("save_reminder", %{"date" => date, "title" => title, "time" => time}, socket) do
    if date == "" or title == "" or time == "" do
      {:noreply, socket}
    else
      new_reminder = %{date: date, title: title, time: time}

      updated_reminders =
        case socket.assigns[:editing_reminder_index] do
          nil -> [new_reminder | socket.assigns.reminders]
          index -> List.replace_at(socket.assigns.reminders, index, new_reminder)
        end

      socket =
        socket
        |> assign(:reminders, updated_reminders)
        |> assign(:show_reminder_form, false)
        |> assign(:editing_reminder, nil)
        |> assign(:editing_reminder_index, nil)

      {:noreply, socket}
    end
  end

  def handle_event("save_meeting", %{"date" => date, "time" => time, "title" => title, "link" => link}, socket) do
    if date == "" or time == "" or title == "" or link == "" do
      {:noreply, socket}
    else
      new_meeting = %{date: date, time: time, title: title, link: link}

      updated_meetings =
        case socket.assigns[:editing_meeting_index] do
          nil -> [new_meeting | socket.assigns.meetings]
          index -> List.replace_at(socket.assigns.meetings, index, new_meeting)
        end

      socket =
        socket
        |> assign(:meetings, updated_meetings)
        |> assign(:show_meeting_form, false)
        |> assign(:editing_meeting, nil)
        |> assign(:editing_meeting_index, nil)

      {:noreply, socket}
    end
  end


  def handle_event("show_meeting_form", _, socket) do
    {:noreply, assign(socket, :show_meeting_form, true)}
  end

  def handle_event("hide_meeting_form", _, socket) do
    {:noreply, assign(socket, :show_meeting_form, false)}
  end

  # def handle_event("save_meeting", %{"date" => date, "time" => time, "title" => title, "link" => link}, socket) do
  #   if date == "" or time == "" or title == "" or link == "" do
  #     {:noreply, socket}
  #   else
  #     new_meeting = %{date: date, time: time, title: title, link: link}
  #     updated_meetings = [new_meeting | socket.assigns.meetings]

  #     socket =
  #       socket
  #       |> assign(:meetings, updated_meetings)
  #       |> assign(:show_meeting_form, false)

  #     {:noreply, socket}
  #   end
  # end
end
