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
        <h3 class="text-lg font-semibold text-gray-900 dark:text-gray-100 mb-4">
          <%= if @reminder, do: "Edit Reminder", else: "Add Reminder" %>
        </h3>

        <.form for={%{}} phx-submit="save_reminder" phx-target={@myself}>
          <Input.input
            type="text"
            name="title"
            value={@reminder && @reminder.title || ""}
            label="Title"
            required
          />

          <Input.input
            type="date"
            name="date"
            value={@reminder && @reminder.date || ""}
            label="Date"
            required
          />

          <Input.input
            type="time"
            name="time"
            value={@reminder && @reminder.time || ""}
            label="Time"
            required
          />

          <div class="mt-4 flex justify-between">
            <Button.button
              type="button"
              phx-click="hide_reminder_form"
              phx-target={@myself}
              color="red"
            >
              Cancel
            </Button.button>
            <Button.button type="submit" color="green">
              Save
            </Button.button>
          </div>
        </.form>
      </Card.card>
    </div>
    """
  end
end
