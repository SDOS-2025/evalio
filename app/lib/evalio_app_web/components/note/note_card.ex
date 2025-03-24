defmodule EvalioAppWeb.NoteCard do
  use EvalioAppWeb, :live_component
  import PetalComponents

  def render(assigns) do
    ~H"""
    <div>
      <.card class="shadow-lg rounded-lg p-4 w-[260px] h-[260px] flex flex-col justify-between">
        <div class="flex justify-between items-center">
          <h3 class="font-bold text-lg"><%= @note.title %></h3>
          <div class="flex items-center space-x-2">
            <!-- Orange Button with Dropdown -->
            <div class="relative">
              <.dropdown>
                <:trigger_element>
                  <div class="w-[60px] h-[30px] bg-[#FF655F] text-white text-sm flex items-center justify-center rounded-full">
                    <!-- Toggle Button (if needed) -->
                  </div>
                </:trigger_element>
                <.dropdown_menu_item phx-click="change_color" phx-value-color="#FF655F" label="Red" />
                <.dropdown_menu_item phx-click="change_color" phx-value-color="#FFA500" label="Orange" />
                <.dropdown_menu_item phx-click="change_color" phx-value-color="#FFFF00" label="Yellow" />
                <.dropdown_menu_item phx-click="change_color" phx-value-color="#008000" label="Green" />
                <.dropdown_menu_item phx-click="change_color" phx-value-color="#0000FF" label="Blue" />
                <.dropdown_menu_item phx-click="change_color" phx-value-color="#800080" label="Purple" />
              </.dropdown>
            </div>

            <!-- Delete Button -->
            <button phx-click="delete_note" phx-value-index={@index} phx-target={@myself} class="text-red-500">
              <HeroiconsV1.Outline.trash class="w-5 h-5 cursor-pointer" />
            </button>
          </div>
        </div>

        <p class="text-gray-600 mt-2 line-clamp-3">
          <%= @note.content %>
        </p>
      </.card>
    </div>
    """
  end

  @impl true
  def handle_event("delete_note", %{"index" => index}, socket) do
    send(self(), {:delete_note, index})  # Send event to parent (NoteContainer)
    {:noreply, socket}
  end

  @impl true
  def handle_event("change_color", %{"color" => color}, socket) do
    # Handle color change logic (e.g., updating assigns, broadcasting, etc.)
    {:noreply, assign(socket, :selected_color, color)}
  end
end
