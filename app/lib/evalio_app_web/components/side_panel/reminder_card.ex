defmodule EvalioAppWeb.ReminderCard do
  use EvalioAppWeb, :live_component
  import PetalComponents
  require Logger

  def mount(socket) do
    {:ok, assign(socket,
      color_picker_mode: false,
      selected_color: "bg-[#4CD964]",  # default green
      transitioning: false,
      deleting: false
    )}
  end

  def update(%{reminder: nil} = assigns, socket) do
    Logger.info("ReminderCard update - Reminder: #{inspect(assigns[:reminder])}")
    {:ok, assign(socket, assigns)}
  end

  def update(%{reminder: reminder} = assigns, socket) when is_map(reminder) do
    # Ensure reminder has a tag, default to "low" if not present
    reminder = Map.put_new(reminder, :tag, "low")

    Logger.info("ReminderCard update - Reminder: #{inspect(reminder)}")

    {:ok, socket
      |> assign(assigns)
      |> assign(:reminder, reminder)
      |> assign(:selected_color, get_color_from_tag(reminder.tag))}
  end

  # Fallback update function for any other case
  def update(assigns, socket) do
    Logger.info("ReminderCard update - Reminder: #{inspect(assigns[:reminder])}")
    {:ok, assign(socket, assigns)}
  end

  defp get_color_from_tag(tag) do
    case tag do
      "urgent" -> "bg-[#FF6B6B]"
      "medium" -> "bg-[#FFB347]"
      "low" -> "bg-[#4CD964]"
      _ -> "bg-[#4CD964]"  # default to green
    end
  end

  def render(assigns) do
    ~H"""
    <div class={[
      "relative h-[62px] bg-white rounded-xl shadow-md border border-[#EBEBEB] overflow-hidden transition-all duration-300 ease-in-out",
      if(@deleting, do: "-translate-x-full opacity-0 h-0 my-0", else: "translate-x-0 opacity-100")
    ]}>
      <!-- Color Picker -->
      <div class={[
        "absolute inset-0 flex h-full w-full transition-transform duration-300 ease-in-out",
        if(@color_picker_mode, do: "translate-x-0", else: "translate-x-full")
      ]}>
        <div class="w-1/3 h-full bg-[#FF6B6B] cursor-pointer hover:opacity-90 transition-opacity"
             phx-click="select_color"
             phx-value-color="bg-[#FF6B6B]"
             phx-value-tag="urgent"
             phx-target={@myself}>
        </div>
        <div class="w-1/3 h-full bg-[#FFB347] cursor-pointer hover:opacity-90 transition-opacity"
             phx-click="select_color"
             phx-value-color="bg-[#FFB347]"
             phx-value-tag="medium"
             phx-target={@myself}>
        </div>
        <div class="w-1/3 h-full bg-[#4CD964] cursor-pointer hover:opacity-90 transition-opacity"
             phx-click="select_color"
             phx-value-color="bg-[#4CD964]"
             phx-value-tag="low"
             phx-target={@myself}>
        </div>
      </div>

      <!-- Regular Card Content -->
      <div class={[
        "absolute inset-0 flex items-start justify-between px-3 py-3 transition-transform duration-300 ease-in-out",
        if(@color_picker_mode, do: "-translate-x-full", else: "translate-x-0")
      ]}>
        <!-- Colored Tag Stripe -->
        <div class={["w-3 h-full absolute left-0 top-0 rounded-l-xl", @selected_color]}
            phx-click="toggle_color_picker"
            phx-target={@myself}
            style="cursor: pointer;">
        </div>

        <div class="flex flex-col gap-1 ml-3">
          <span class="text-sm text-[#171717]"><%= @reminder.title %></span>
          <span class="text-xs text-[#666666]">
            <%= @reminder.time %> | <%= format_date(@reminder.date) %>
          </span>
        </div>

        <!-- Actions: Complete, Edit, Delete -->
        <div class="flex items-center gap-3 ml-auto">
          <!-- Completion Checkbox -->
          <div class="w-4 h-4 rounded border-2 border-[#171717] cursor-pointer hover:bg-[#EBEBEB]"
               phx-click="toggle_completion"
               phx-target={@myself}/>

          <!-- Edit (Pencil Icon) -->
          <button phx-click="edit_reminder" phx-target={@myself} class="text-[#171717] hover:text-[#999999]">
            <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15.232 5.232l3.536 3.536m-2.036-5.036a2.5 2.5 0 113.536 3.536L6.5 21.036H3v-3.572L16.732 3.732z" />
            </svg>
          </button>

          <!-- Delete (Trash Icon) -->
          <button phx-click="start_delete" phx-target={@myself} class="text-[#171717] hover:text-[#999999]">
            <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 7l-.867 12.142A2 2 0 0116.138 21H7.862a2 2 0 01-1.995-1.858L5 7m5 4v6m4-6v6M9 7h6m2 0a2 2 0 01-2-2H9a2 2 0 01-2 2h10z" />
            </svg>
          </button>
        </div>
      </div>
    </div>
    """
  end

  defp format_date(date) when is_binary(date) do
    case Date.from_iso8601(date) do
      {:ok, date} -> Calendar.strftime(date, "%d/%m/%Y")
      _ -> date
    end
  end

  defp format_date(date), do: date

  def handle_event("toggle_color_picker", _params, socket) do
    {:noreply, assign(socket, color_picker_mode: !socket.assigns.color_picker_mode)}
  end

  def handle_event("select_color", %{"color" => color, "tag" => tag}, socket) do
    # Update the reminder's tag in the parent component
    send(self(), {:update_reminder_tag, socket.assigns.reminder.id, tag})

    {:noreply, socket
      |> assign(selected_color: color)
      |> assign(color_picker_mode: false)}
  end

  def handle_event("toggle_completion", _params, socket) do
    send(self(), {:toggle_reminder_completion, socket.assigns.reminder.id})
    {:noreply, socket}
  end

  def handle_event("start_delete", _params, socket) do
    if connected?(socket) do
      # Start the deletion animation
      socket = assign(socket, deleting: true)

      # After animation completes, send the finish_delete event
      Process.send_after(self(), {:finish_delete, socket.assigns.reminder.id}, 300)

      {:noreply, socket}
    else
      {:noreply, socket}
    end
  end

  def handle_info({:finish_delete, id}, socket) do
    # Send the delete event directly to the ReminderContainer component
    send_update(EvalioAppWeb.ReminderContainer, id: "reminder-container", delete_reminder_id: id)
    {:noreply, socket}
  end

  def handle_event("edit_reminder", _params, socket) do
    send(self(), {socket.assigns.on_edit, socket.assigns.reminder.id})
    {:noreply, socket}
  end
end
