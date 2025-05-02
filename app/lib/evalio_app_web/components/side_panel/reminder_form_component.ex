defmodule EvalioAppWeb.ReminderFormComponent do
  use EvalioAppWeb, :live_component

  # Use aliases instead of imports to avoid ambiguity
  alias PetalComponents.Card
  alias PetalComponents.Button
  alias PetalComponents.Input

  alias EvalioApp.Reminder

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <Card.card class="w-96 bg-white dark:bg-gray-800 shadow-lg rounded-lg p-6">
        <h3 class="text-lg font-semibold text-gray-900 dark:text-gray-100 mb-6">
          {if @reminder, do: "Edit Reminder", else: "Add Reminder"}
        </h3>

        <.form for={@reminder} phx-submit="save_reminder" phx-target={@myself} class="space-y-4">
          <!-- Hidden ID field for editing existing reminders -->
          <%= if @reminder && @reminder.id do %>
            <Input.input type="hidden" name="id" value={@reminder.id} />
          <% end %>

          <div class="mb-4 w-full">
            <Input.input
              type="text"
              name="title"
              value={(@reminder && @reminder.title) || ""}
              label="Title"
              placeholder="Title"
              class="w-full rounded-md border-gray-300 dark:border-gray-600 focus:border-gray-400 focus:ring-gray-400 text-black"
              required
            />
          </div>

          <div class="mb-4 w-full">
            <Input.input
              type="date"
              name="date"
              value={(@reminder && @reminder.date) || ""}
              label="Date"
              class="w-full rounded-md border-gray-300 dark:border-gray-600 focus:border-gray-400 focus:ring-gray-400 text-black"
              required
            />
          </div>

          <div class="mb-4 w-full">
            <Input.input
              type="time"
              name="time"
              value={(@reminder && @reminder.time) || ""}
              label="Time"
              class="w-full rounded-md border-gray-300 dark:border-gray-600 focus:border-gray-400 focus:ring-gray-400 text-black"
              required
            />
          </div>

          <div class="mt-6 flex justify-between">
            <.button label="Cancel" phx-click="hide_reminder_form" phx-target={@myself} color="white" />
            <.button
              label="Save"
              type="submit"
              color="black"
              class="px-3 py-2 rounded-md text-m font-medium bg-black text-white hover:bg-gray-700 hover:text-white transition-colors"
            />
          </div>
        </.form>
      </Card.card>
    </div>
    """
  end

  @impl true
  def handle_event("save_reminder", params, socket) do
    # Forward the save event to the parent component
    send_update(EvalioAppWeb.ReminderContainer, id: "reminder-container", save_reminder: params)
    {:noreply, socket}
  end

  @impl true
  def handle_event("hide_reminder_form", _params, socket) do
    # Forward the hide event to the parent component
    send_update(EvalioAppWeb.ReminderContainer,
      id: "reminder-container",
      hide_reminder_form: true
    )

    {:noreply, socket}
  end
end
