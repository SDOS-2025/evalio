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
        <h3 class="text-lg font-semibold text-gray-900 dark:text-gray-100 mb-4">
          <%= if @meeting, do: "Edit Meeting", else: "Add Meeting" %>
        </h3>

        <.form for={%{}} phx-submit="save_meeting" phx-target={@myself}>
          <!-- Hidden ID field for editing existing meetings -->
          <%= if @meeting && @meeting.id do %>
            <Input.input
              type="hidden"
              name="id"
              value={@meeting.id}
            />
          <% end %>

          <Input.input
            type="text"
            name="title"
            value={@meeting && @meeting.title || ""}
            label="Title"
            required
          />

          <Input.input
            type="date"
            name="date"
            value={@meeting && @meeting.date || ""}
            label="Date"
            required
          />

          <Input.input
            type="time"
            name="time"
            value={@meeting && @meeting.time || ""}
            label="Time"
            required
          />

          <Input.input
            type="url"
            name="link"
            value={@meeting && @meeting.link || ""}
            label="Link"
            required
          />

          <div class="mt-4 flex justify-between">
            <Button.button
              type="button"
              phx-click="hide_meeting_form"
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
