defmodule EvalioAppWeb.ReminderFormComponent do
  use EvalioAppWeb, :live_component

  @impl true
  def render(assigns) do
    ~H"""
    <div>  <!-- This ensures a single static root element -->
      <.card class="w-96 bg-white dark:bg-gray-800 shadow-lg rounded-lg p-6">

        <!-- CHANGED: Dynamic Heading based on add/edit -->
        <h3 class="text-lg font-semibold text-gray-900 dark:text-gray-100 mb-4">
          <%= if @reminder, do: "Edit Reminder", else: "Add Reminder" %>
        </h3>

        <form phx-submit="save_reminder" phx-target={@myself}>

          <!-- Title Field -->
          <label class="block text-sm text-gray-700 dark:text-gray-300">Title</label>

          <!-- CHANGED: Added value attribute for pre-filling -->
          <input type="text" name="title"
            value={@reminder && @reminder.title || ""}
            class="w-full px-3 py-2 rounded-lg bg-gray-200 dark:bg-gray-700 mb-2">

          <!-- Date Field -->
          <label class="block text-sm text-gray-700 dark:text-gray-300">Date</label>

          <!-- CHANGED: Added value attribute for pre-filling -->
          <input type="date" name="date"
            value={@reminder && @reminder.date || ""}
            class="w-full px-3 py-2 rounded-lg bg-gray-200 dark:bg-gray-700 mb-2">

          <!-- Time Field -->
          <label class="block text-sm text-gray-700 dark:text-gray-300">Time</label>

          <!-- CHANGED: Added value attribute for pre-filling -->
          <input type="time" name="time"
            value={@reminder && @reminder.time || ""}
            class="w-full px-3 py-2 rounded-lg bg-gray-200 dark:bg-gray-700 mb-4">

          <div class="flex justify-end space-x-2">
            <button type="button" phx-click="hide_reminder_form" phx-target={@myself}
              class="px-4 py-2 bg-gray-400 dark:bg-gray-600 text-white rounded-lg">
              Cancel
            </button>
            <button type="submit" class="px-4 py-2 bg-blue-500 dark:bg-blue-700 text-white rounded-lg">
              Save
            </button>
          </div>
        </form>
      </.card>
    </div>
    """
  end
end
