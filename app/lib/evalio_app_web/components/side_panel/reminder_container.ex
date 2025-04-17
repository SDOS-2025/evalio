defmodule EvalioAppWeb.ReminderContainer do
  use EvalioAppWeb, :live_component

  alias PetalComponents.Card
  alias EvalioAppWeb.ReminderCard

  def render(assigns) do
    ~H"""
    <div>
      <Card.card class="w-full max-w-[90%] mx-auto aspect-square bg-white dark:bg-gray-800 shadow-md rounded-2xl relative p-4 flex flex-col">
        <div class="flex justify-between items-center">
          <h4 class="text-xl font-bold text-gray-800 dark:text-gray-200">Reminders</h4>
          <button phx-click="show_reminder_form" phx-target={@parent_pid}>
            <span class="text-2xl text-gray-600 dark:text-gray-300">+</span>
          </button>
        </div>

        <div class="mt-4 flex-grow w-full max-h-[310px] overflow-y-auto bg-transparent rounded-lg px-0 py-2 space-y-2 transition-all duration-300 ease-in-out">
          <%= for {reminder, index} <- Enum.with_index(@sorted_reminders) do %>
            <div class="transition-all duration-300 ease-in-out">
              <.live_component
                module={ReminderCard}
                id={"reminder-#{reminder.id}"}
                reminder={reminder}
                on_delete="delete_reminder"
                on_edit="edit_reminder"
              />
            </div>
          <% end %>
        </div>
      </Card.card>
    </div>
    """
  end

  def handle_event("show_reminder_form", _, socket) do
    # Reset editing state when showing the form for a new reminder
    socket =
      socket
      |> assign(:show_reminder_form, true)
      |> assign(:editing_reminder, nil)

    {:noreply, socket}
  end

  def handle_event("edit_reminder", %{"id" => id}, socket) do
    # Forward the event to the parent
    send_update(EvalioAppWeb.SidePanel, id: socket.assigns.parent_id, edit_reminder_id: id)
    {:noreply, socket}
  end

  def handle_event("delete_reminder", %{"id" => id}, socket) do
    # Forward the event to the parent
    send_update(EvalioAppWeb.SidePanel, id: socket.assigns.parent_id, delete_reminder_id: id)
    {:noreply, socket}
  end

  # Sort reminders by date and time (most recent first)
  defp sort_reminders(reminders) do
    Enum.sort_by(reminders, fn reminder ->
      {reminder.date, reminder.time}
    end, :asc)
  end
end
