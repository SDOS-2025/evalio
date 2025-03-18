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
            <!-- Orange Button -->
            <div class="w-[60px] h-[30px] bg-[#FF655F] text-white text-sm flex items-center justify-center rounded-full">
              <!-- Toggle Button (if needed) -->
            </div>
            <!-- Delete Button -->
            <button phx-click="delete_note" phx-value-index={@index} phx-target={@myself} class="text-red-500">
              <HeroiconsV1.Outline.trash class="w-5 h-5 cursor-pointer" />
            </button>
          </div>
        </div>

        <p class="text-gray-600 mt-2 overflow-hidden text-ellipsis">
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
end
