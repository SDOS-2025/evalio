defmodule EvalioAppWeb.MeetingContainer do
  use EvalioAppWeb, :live_component

  alias PetalComponents.Card
  alias EvalioAppWeb.MeetingCard

  def render(assigns) do
    ~H"""
    <div>
      <Card.card class="w-full max-w-[90%] mx-auto aspect-square bg-white dark:bg-gray-800 shadow-md rounded-2xl relative p-4 flex flex-col">
        <div class="flex justify-between items-center">
          <h4 class="text-xl font-bold text-gray-800 dark:text-gray-200">Meetings</h4>
          <button phx-click="show_meeting_form" phx-target={@parent_pid}>
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
    """
  end

  def handle_event("show_meeting_form", _, socket) do
    # Reset editing state when showing the form for a new meeting
    socket =
      socket
      |> assign(:show_meeting_form, true)
      |> assign(:editing_meeting, nil)

    {:noreply, socket}
  end

  def handle_event("edit_meeting", %{"id" => id}, socket) do
    # Forward the event to the parent
    send_update(EvalioAppWeb.SidePanel, id: socket.assigns.parent_id, edit_meeting_id: id)
    {:noreply, socket}
  end

  def handle_event("delete_meeting", %{"id" => id}, socket) do
    # Forward the event to the parent
    send_update(EvalioAppWeb.SidePanel, id: socket.assigns.parent_id, delete_meeting_id: id)
    {:noreply, socket}
  end

  # Sort meetings by date and time (most recent first)
  defp sort_meetings(meetings) do
    Enum.sort_by(meetings, fn meeting ->
      {meeting.date, meeting.time}
    end, :asc)
  end
end
