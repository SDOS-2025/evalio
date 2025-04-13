defmodule EvalioAppWeb.SidePanel.Reminder do
  use EvalioAppWeb, :live_component
  alias EvalioAppWeb.SidePanel.ReminderTagMenu

  def mount(socket) do
    sample_reminders = [
      %{
        id: 1,
        text: "Review pull request #42",
        time: ~U[2024-03-20 10:00:00Z],
        completed: false,
        tag: "red"
      },
      %{
        id: 2,
        text: "Team standup meeting",
        time: ~U[2024-03-20 14:30:00Z],
        completed: false,
        tag: "blue"
      },
      %{
        id: 3,
        text: "Submit project documentation",
        time: ~U[2024-03-21 16:00:00Z],
        completed: false,
        tag: "green"
      },
      %{
        id: 4,
        text: "Code review with Sarah",
        time: ~U[2024-03-22 11:00:00Z],
        completed: true,
        tag: "purple"
      },
      %{
        id: 5,
        text: "Weekly project planning",
        time: ~U[2024-03-23 09:00:00Z],
        completed: false,
        tag: "orange"
      },
      %{
        id: 6,
        text: "Client presentation preparation",
        time: ~U[2024-03-23 13:00:00Z],
        completed: false,
        tag: "yellow"
      },
      %{
        id: 7,
        text: "Update API documentation",
        time: ~U[2024-03-24 15:00:00Z],
        completed: false,
        tag: "blue"
      }
    ]

    {:ok, assign(socket,
      show_form: false,
      reminders: sample_reminders
    )}
  end

  def render(assigns) do
    ~H"""
    <div class="w-full">
      <div class="bg-white rounded-xl shadow-md border border-gray-200 p-4">
        <div class="flex items-center justify-between mb-4">
          <h2 class="text-xl font-semibold text-[#171717]">Reminders</h2>
          <button class="w-8 h-8 rounded-lg bg-[#F5F5F5] hover:bg-[#EBEBEB] transition-colors flex items-center justify-center"
            phx-click="toggle_form"
            phx-target={@myself}>
            <svg class="w-5 h-5 text-[#171717]" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
              <path d="M12 5V19M5 12H19" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
            </svg>
          </button>
        </div>

        <%= if Enum.empty?(@reminders) do %>
          <div class="flex flex-col items-center justify-center py-6">
            <div class="w-12 h-12 mb-3 rounded-full bg-[#F5F5F5] flex items-center justify-center">
              <svg class="w-6 h-6 text-[#666666]" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
                <path d="M12 6v6l4 2M12 2a10 10 0 100 20 10 10 0 000-20z" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
              </svg>
            </div>
            <p class="text-[#666666] text-center">No reminders yet</p>
            <p class="text-sm text-[#999999] text-center mt-1">Add your first reminder to stay organized</p>
          </div>
        <% else %>
          <div class="space-y-2 max-h-[300px] overflow-y-auto pr-2 scrollbar-thin scrollbar-thumb-gray-300 scrollbar-track-transparent">
            <%= for reminder <- @reminders do %>
              <div class="flex relative bg-[#F5F5F5] rounded-lg overflow-hidden h-12">
                <div class={"w-2 h-full absolute left-0 top-0 #{tag_color_class(reminder.tag)}"}
                     phx-click={JS.toggle(to: "#reminder-dropdown-menu-#{reminder.id}")}
                     style="cursor: pointer;">
                </div>
                <div class="flex-1 flex items-center justify-between py-2 px-3 pl-4">
                  <div class="flex items-center space-x-3">
                    <div class="w-4 h-4 rounded border-2 border-[#171717] cursor-pointer hover:bg-[#EBEBEB] transition-colors"/>
                    <span class="text-sm text-[#171717]"><%= reminder.text %></span>
                  </div>
                  <div class="flex items-center space-x-2">
                    <span class="text-xs text-[#666666]"><%= Calendar.strftime(reminder.time, "%a %d/%m %H:%M") %></span>
                    <button class="text-[#666666] hover:text-[#171717] transition-colors">
                      <svg class="w-4 h-4" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
                        <path d="M12 5v7l3 3m4-3a9 9 0 11-18 0 9 9 0 0118 0z" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
                      </svg>
                    </button>
                    <button class="text-[#666666] hover:text-red-500 transition-colors">
                      <svg class="w-4 h-4" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
                        <path d="M19 7l-.867 12.142A2 2 0 0116.138 21H7.862a2 2 0 01-1.995-1.858L5 7m5 4v6m4-6v6m1-10V4a1 1 0 00-1-1h-4a1 1 0 00-1 1v3M4 7h16" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
                      </svg>
                    </button>
                  </div>
                </div>
                <div id={"reminder-dropdown-menu-#{reminder.id}"} class="hidden absolute z-10 mt-2 left-0 top-full w-[120px] bg-white rounded-lg py-2 shadow-lg border border-gray-200 max-h-[200px] overflow-y-auto scrollbar-thin scrollbar-thumb-gray-300 scrollbar-track-gray-100">
                  <div class="flex flex-col" role="menu" aria-orientation="vertical">
                    <button type="button" phx-click="change_tag" phx-value-tag="red" phx-value-id={reminder.id} phx-target={@myself} class="group w-full px-4 py-2 flex items-center space-x-3 hover:bg-[#FF655F] transition-all text-gray-700" role="menuitem">
                      <div class="w-3 h-3 rounded-full bg-[#FF655F] transition-all group-hover:w-full group-hover:h-[20px]"></div>
                      <span class="text-sm transition-opacity group-hover:opacity-0">Red</span>
                    </button>
                    <button type="button" phx-click="change_tag" phx-value-tag="orange" phx-value-id={reminder.id} phx-target={@myself} class="group w-full px-4 py-2 flex items-center space-x-3 hover:bg-[#FF9F0B] transition-all text-gray-700" role="menuitem">
                      <div class="w-3 h-3 rounded-full bg-[#FF9F0B] transition-all group-hover:w-full group-hover:h-[20px]"></div>
                      <span class="text-sm transition-opacity group-hover:opacity-0">Orange</span>
                    </button>
                    <button type="button" phx-click="change_tag" phx-value-tag="yellow" phx-value-id={reminder.id} phx-target={@myself} class="group w-full px-4 py-2 flex items-center space-x-3 hover:bg-[#FFD60D] transition-all text-gray-700" role="menuitem">
                      <div class="w-3 h-3 rounded-full bg-[#FFD60D] transition-all group-hover:w-full group-hover:h-[20px]"></div>
                      <span class="text-sm transition-opacity group-hover:opacity-0">Yellow</span>
                    </button>
                    <button type="button" phx-click="change_tag" phx-value-tag="green" phx-value-id={reminder.id} phx-target={@myself} class="group w-full px-4 py-2 flex items-center space-x-3 hover:bg-[#32D74B] transition-all text-gray-700" role="menuitem">
                      <div class="w-3 h-3 rounded-full bg-[#32D74B] transition-all group-hover:w-full group-hover:h-[20px]"></div>
                      <span class="text-sm transition-opacity group-hover:opacity-0">Green</span>
                    </button>
                    <button type="button" phx-click="change_tag" phx-value-tag="blue" phx-value-id={reminder.id} phx-target={@myself} class="group w-full px-4 py-2 flex items-center space-x-3 hover:bg-[#02B1FF] transition-all text-gray-700" role="menuitem">
                      <div class="w-3 h-3 rounded-full bg-[#02B1FF] transition-all group-hover:w-full group-hover:h-[20px]"></div>
                      <span class="text-sm transition-opacity group-hover:opacity-0">Blue</span>
                    </button>
                    <button type="button" phx-click="change_tag" phx-value-tag="purple" phx-value-id={reminder.id} phx-target={@myself} class="group w-full px-4 py-2 flex items-center space-x-3 hover:bg-[#9849E8] transition-all text-gray-700" role="menuitem">
                      <div class="w-3 h-3 rounded-full bg-[#9849E8] transition-all group-hover:w-full group-hover:h-[20px]"></div>
                      <span class="text-sm transition-opacity group-hover:opacity-0">Purple</span>
                    </button>
                    <button type="button" phx-click="change_tag" phx-value-tag="none" phx-value-id={reminder.id} phx-target={@myself} class="group w-full px-4 py-2 flex items-center space-x-3 hover:bg-[#D9D9D9] transition-all text-gray-700" role="menuitem">
                      <div class="w-3 h-3 rounded-full bg-[#D9D9D9] transition-all group-hover:w-full group-hover:h-[20px]"></div>
                      <span class="text-sm transition-opacity group-hover:opacity-0">No Tag</span>
                    </button>
                  </div>
                </div>
              </div>
            <% end %>
          </div>
        <% end %>

        <%= if @show_form do %>
          <div class="mt-4">
            <form phx-submit="save_reminder" phx-target={@myself} class="space-y-4">
              <input
                type="text"
                name="text"
                class="w-full px-4 py-2 rounded-lg border border-gray-200 focus:outline-none focus:ring-2 focus:ring-blue-500"
                placeholder="What do you need to remember?"
                required
              />
              <div class="flex justify-end space-x-2">
                <button
                  type="button"
                  class="px-4 py-2 text-[#666666] hover:text-[#171717] transition-colors"
                  phx-click="cancel_reminder"
                  phx-target={@myself}
                >
                  Cancel
                </button>
                <button
                  type="submit"
                  class="px-4 py-2 bg-blue-500 text-white rounded-lg hover:bg-blue-600 transition-colors"
                >
                  Add Reminder
                </button>
              </div>
            </form>
          </div>
        <% end %>
      </div>
    </div>
    """
  end

  defp tag_color_class(tag) do
    case tag do
      "red" -> "bg-[#FF655F]"
      "orange" -> "bg-[#FF9F0B]"
      "yellow" -> "bg-[#FFD60D]"
      "green" -> "bg-[#32D74B]"
      "blue" -> "bg-[#02B1FF]"
      "purple" -> "bg-[#9849E8]"
      _ -> "bg-[#D9D9D9]"
    end
  end

  def handle_event("toggle_form", _, socket) do
    {:noreply, assign(socket, show_form: !socket.assigns.show_form)}
  end

  def handle_event("cancel_reminder", _, socket) do
    {:noreply, assign(socket, show_form: false)}
  end

  def handle_event("save_reminder", %{"text" => text}, socket) do
    reminder = %{
      id: System.unique_integer([:positive]),
      text: text,
      time: DateTime.utc_now(),
      completed: false,
      tag: "none"
    }

    {:noreply, socket
      |> assign(reminders: [reminder | socket.assigns.reminders])
      |> assign(show_form: false)}
  end

  def handle_event("change_tag", %{"tag" => tag, "id" => id}, socket) do
    updated_reminders = Enum.map(socket.assigns.reminders, fn reminder ->
      if reminder.id == String.to_integer(id) do
        %{reminder | tag: tag}
      else
        reminder
      end
    end)

    {:noreply, assign(socket, reminders: updated_reminders)}
  end
end
