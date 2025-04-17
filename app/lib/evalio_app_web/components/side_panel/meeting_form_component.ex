defmodule EvalioAppWeb.MeetingFormComponent do
  use EvalioAppWeb, :live_component

  # Use aliases instead of imports to avoid ambiguity
  alias PetalComponents.Card
  alias PetalComponents.Button
  alias PetalComponents.Input

  alias EvalioApp.Meeting

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <Card.card class="w-96 bg-white dark:bg-gray-800 shadow-lg rounded-lg p-6">
        <h3 class="text-lg font-semibold text-gray-900 dark:text-gray-100 mb-6">
          <%= if @meeting, do: "Edit Meeting", else: "Add Meeting" %>
        </h3>

        <.form for={%{}} phx-submit="save_meeting" phx-target={@myself} class="space-y-4">
          <!-- Hidden ID field for editing existing meetings -->
          <%= if @meeting && @meeting.id do %>
            <Input.input
              type="hidden"
              name="id"
              value={@meeting.id}
            />
          <% end %>

          <div class="mb-4 w-full">
            <Input.input
              type="text"
              name="title"
              value={@meeting && @meeting.title || ""}
              label="Title"
              placeholder="Title"
              class="w-full rounded-md border-gray-300 dark:border-gray-600 focus:border-gray-400 focus:ring-gray-400"
              required
            />
          </div>

          <div class="mb-4 w-full">
            <Input.input
              type="date"
              name="date"
              value={@meeting && @meeting.date || ""}
              label="Date"
              class="w-full rounded-md border-gray-300 dark:border-gray-600 focus:border-gray-400 focus:ring-gray-400"
              required
            />
          </div>

          <div class="mb-4 w-full">
            <Input.input
              type="time"
              name="time"
              value={@meeting && @meeting.time || ""}
              label="Time"
              class="w-full rounded-md border-gray-300 dark:border-gray-600 focus:border-gray-400 focus:ring-gray-400"
              required
            />
          </div>

          <div class="mb-4 w-full">
            <Input.input
              type="url"
              name="link"
              value={@meeting && @meeting.link || ""}
              label="Link"
              placeholder="Link"
              class="w-full rounded-md border-gray-300 dark:border-gray-600 focus:border-gray-400 focus:ring-gray-400"
              required
            />
          </div>

          <div class="mt-6 flex justify-between">
            <.button label="Cancel" phx-click="hide_meeting_form" phx-target={@myself} color="white" />
            <.button label="Save" type="submit" color = "black" class="px-3 py-2 rounded-md text-m font-medium bg-black text-white hover:bg-gray-700 hover:text-white transition-colors" />
          </div>
        </.form>
      </Card.card>
    </div>
    """
  end
end
