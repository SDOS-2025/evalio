defmodule EvalioAppWeb.MeetingFormComponent do
  use EvalioAppWeb, :live_component

  @impl true
  def render(assigns) do
    ~H"""
    <div>  <!-- This ensures a single static root element -->
      <.card class="w-96 bg-white dark:bg-gray-800 shadow-lg rounded-lg p-6">

        <!-- Dynamic Heading based on add/edit -->
        <h3 class="text-lg font-semibold text-gray-900 dark:text-gray-100 mb-4">
          <%= if @meeting, do: "Edit Meeting", else: "Add Meeting" %>
        </h3>

        <form phx-submit="save_meeting" phx-target={@myself}>

          <!-- Title Field -->
          <label class="block text-sm text-gray-700 dark:text-gray-300">Title</label>
          <input type="text" name="title"
            value={@meeting && @meeting.title || ""}
            class="w-full px-3 py-2 rounded-lg bg-gray-200 dark:bg-gray-700 mb-2" required>

          <!-- Date Field -->
          <label class="block text-sm text-gray-700 dark:text-gray-300">Date</label>
          <input type="date" name="date"
            value={@meeting && @meeting.date || ""}
            class="w-full px-3 py-2 rounded-lg bg-gray-200 dark:bg-gray-700 mb-2" required>

          <!-- Time Field -->
          <label class="block text-sm text-gray-700 dark:text-gray-300">Time</label>
          <input type="time" name="time"
            value={@meeting && @meeting.time || ""}
            class="w-full px-3 py-2 rounded-lg bg-gray-200 dark:bg-gray-700 mb-2" required>

          <!-- Link Field -->
          <label class="block text-sm text-gray-700 dark:text-gray-300">Link</label>
          <input type="url" name="link"
            value={@meeting && @meeting.link || ""}
            class="w-full px-3 py-2 rounded-lg bg-gray-200 dark:bg-gray-700 mb-4" required>

          <div class="flex justify-end space-x-2">
            <button type="button" phx-click="hide_meeting_form" phx-target={@myself}
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
