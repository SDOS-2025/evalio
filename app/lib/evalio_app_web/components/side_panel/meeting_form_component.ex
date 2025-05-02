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
          {if @meeting, do: "Edit Meeting", else: "Add Meeting"}
        </h3>

        <.form for={%{}} phx-submit="save_meeting" phx-target={@myself} class="space-y-4">
          <!-- Hidden ID field for editing existing meetings -->
          <%= if @meeting && @meeting.id do %>
            <Input.input type="hidden" name="id" value={@meeting.id} />
          <% end %>

          <div class="mb-4 w-full">
            <Input.input
              type="text"
              name="title"
              value={(@meeting && @meeting.title) || ""}
              label="Title"
              placeholder="Title"
              class="w-full rounded-md border-gray-300 dark:border-gray-600 focus:border-gray-400 focus:ring-gray-400 text-black"
              required
            />
          </div>

          <div class="mb-4 w-full relative">
            <div class="relative">
              <Input.input
                type="date"
                name="date"
                id="meeting-date"
                value={(@meeting && @meeting.date) || ""}
                label="Date"
                class="w-full rounded-md border-gray-300 dark:border-gray-600 focus:border-gray-400 focus:ring-gray-400 text-black pl-10"
                required
              />
              <div class="absolute inset-y-0 left-0 pl-3 flex items-center">
                <svg
                  class="h-5 w-5 text-gray-400 hover:text-gray-600 cursor-pointer"
                  xmlns="http://www.w3.org/2000/svg"
                  fill="none"
                  viewBox="0 0 24 24"
                  stroke="currentColor"
                  phx-click="focus_date"
                  phx-target={@myself}
                >
                  <path
                    stroke-linecap="round"
                    stroke-linejoin="round"
                    stroke-width="2"
                    d="M8 7V3m8 4V3m-9 8h10M5 21h14a2 2 0 002-2V7a2 2 0 00-2-2H5a2 2 0 00-2 2v12a2 2 0 002 2z"
                  />
                </svg>
              </div>
            </div>
          </div>

          <div class="mb-4 w-full relative">
            <div class="relative">
              <Input.input
                type="time"
                name="time"
                id="meeting-time"
                value={(@meeting && @meeting.time) || ""}
                label="Time"
                class="w-full rounded-md border-gray-300 dark:border-gray-600 focus:border-gray-400 focus:ring-gray-400 text-black pl-10"
                required
              />
              <div class="absolute inset-y-0 left-0 pl-3 flex items-center">
                <svg
                  class="h-5 w-5 text-gray-400 hover:text-gray-600 cursor-pointer"
                  xmlns="http://www.w3.org/2000/svg"
                  fill="none"
                  viewBox="0 0 24 24"
                  stroke="currentColor"
                  phx-click="focus_time"
                  phx-target={@myself}
                >
                  <path
                    stroke-linecap="round"
                    stroke-linejoin="round"
                    stroke-width="2"
                    d="M12 8v4l3 3m6-3a9 9 0 11-18 0 9 9 0 0118 0z"
                  />
                </svg>
              </div>
            </div>
          </div>

          <div class="mb-4 w-full">
            <Input.input
              type="url"
              name="link"
              value={(@meeting && @meeting.link) || ""}
              label="Link"
              placeholder="Meeting Link"
              class="w-full rounded-md border-gray-300 dark:border-gray-600 focus:border-gray-400 focus:ring-gray-400 text-black"
            />
          </div>

          <div class="mt-6 flex justify-between">
            <.button label="Cancel" phx-click="hide_meeting_form" phx-target={@myself} color="white" />
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
  def handle_event("focus_date", _params, socket) do
    # Push a JavaScript event to focus the date input
    {:noreply, push_event(socket, "focus_date", %{})}
  end

  @impl true
  def handle_event("focus_time", _params, socket) do
    # Push a JavaScript event to focus the time input
    {:noreply, push_event(socket, "focus_time", %{})}
  end

  @impl true
  def handle_event("save_meeting", params, socket) do
    # Forward the save event to the parent component
    send_update(EvalioAppWeb.MeetingContainer, id: "meeting-container", save_meeting: params)
    {:noreply, socket}
  end

  @impl true
  def handle_event("hide_meeting_form", _params, socket) do
    # Forward the hide event to the parent component
    send_update(EvalioAppWeb.MeetingContainer, id: "meeting-container", hide_meeting_form: true)
    {:noreply, socket}
  end
end
