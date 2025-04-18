defmodule EvalioAppWeb.MeetingContainer do
  use EvalioAppWeb, :live_component
  alias PetalComponents.Card
  alias EvalioAppWeb.MeetingCard
  alias EvalioAppWeb.MeetingFormComponent
  alias EvalioAppWeb.TagManager
  alias EvalioApp.Meeting

  def render(assigns) do
    ~H"""
    <div>
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

      <%= if @show_meeting_form do %>
        <div class="fixed inset-0 z-[9999]">
          <div class="fixed inset-0 bg-black/30 backdrop-blur-lg"></div>
          <div class="fixed inset-0 flex items-center justify-center">
            <div class="relative z-[10000]">
              <.live_component module={MeetingFormComponent} id="meeting_form" myself={@myself} meeting={@editing_meeting} />
            </div>
          </div>
        </div>
      <% end %>
    </div>
    """
  end

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
    meetings = assigns[:meetings] || []

    # Sort meetings
    sorted_meetings = sort_meetings(meetings)

    socket =
      socket
      |> assign(:meetings, meetings)
      |> assign(:sorted_meetings, sorted_meetings)
      |> assign(:show_meeting_form, assigns[:show_meeting_form] || false)
      |> assign_new(:editing_meeting, fn -> nil end)

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

  def handle_event("hide_meeting_form", _params, socket) do
    {:noreply, assign(socket, :show_meeting_form, false)}
  end

  # Helper function to sort meetings
  defp sort_meetings(meetings) do
    Enum.sort_by(meetings, fn meeting ->
      {meeting.date, meeting.time}
    end)
  end
end
