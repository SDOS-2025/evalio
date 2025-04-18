defmodule EvalioAppWeb.ReminderContainer do
  use EvalioAppWeb, :live_component
  alias PetalComponents.Card
  alias EvalioAppWeb.ReminderCard
  alias EvalioAppWeb.ReminderFormComponent
  alias EvalioAppWeb.TagManager
  alias EvalioApp.Reminder

  def render(assigns) do
    ~H"""
    <div>
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
              module={ReminderCard}
              id={"reminder-#{reminder.id}"}
              reminder={reminder}
              on_delete="delete_reminder"
              on_edit="edit_reminder"
            />
          </div>
        <% end %>
      </div>

      <%= if @show_reminder_form do %>
        <div class="fixed inset-0 z-[9999]">
          <div class="fixed inset-0 bg-black/30 backdrop-blur-lg"></div>
          <div class="fixed inset-0 flex items-center justify-center">
            <div class="relative z-[10000]">
              <.live_component module={ReminderFormComponent} id="reminder_form" myself={@myself} reminder={@editing_reminder} />
            </div>
          </div>
        </div>
      <% end %>
    </Card.card>
    </div>
    """
  end

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

  def update(%{delete_reminder_id: id} = _assigns, socket) do
    updated_reminders = Enum.reject(socket.assigns.reminders, &(&1.id == id))
    sorted_reminders = sort_reminders(updated_reminders)

    {:ok, assign(socket,
      reminders: updated_reminders,
      sorted_reminders: sorted_reminders
    )}
  end

  def update(%{edit_reminder_id: id} = _assigns, socket) do
    # Find the reminder to edit
    reminder = Enum.find(socket.assigns.reminders, &(&1.id == id))

    socket =
      socket
      |> assign(:show_reminder_form, true)
      |> assign(:editing_reminder, reminder)

    {:ok, socket}
  end

  def update(assigns, socket) do
    reminders = assigns[:reminders] || []

    # Sort reminders
    sorted_reminders = sort_reminders(reminders)

    socket =
      socket
      |> assign(:reminders, reminders)
      |> assign(:sorted_reminders, sorted_reminders)
      |> assign(:show_reminder_form, assigns[:show_reminder_form] || false)
      |> assign_new(:editing_reminder, fn -> nil end)

    {:ok, socket}
  end

  def handle_event("show_reminder_form", _params, socket) do
    {:noreply, assign(socket, show_reminder_form: true, editing_reminder: nil)}
  end

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

  def handle_event("save_reminder", %{"date" => date, "time" => time, "title" => title}, socket) do
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

  def handle_event("hide_reminder_form", _params, socket) do
    {:noreply, assign(socket, :show_reminder_form, false)}
  end

  # Helper function to sort reminders
  defp sort_reminders(reminders) do
    Enum.sort_by(reminders, fn reminder ->
      {reminder.date, reminder.time}
    end)
  end
end
