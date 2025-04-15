defmodule EvalioAppWeb.NoteCard do
  use EvalioAppWeb, :live_component
  import PetalComponents

  alias EvalioAppWeb.NoteTagMenu
  alias EvalioApp.Note

  def render(assigns) do
    ~H"""
    <div class="relative">
      <%= if @editing do %>
        <!-- Full-screen overlay with blur effect when editing -->
        <div class="fixed inset-0 bg-black/30 backdrop-blur-lg flex items-center justify-center transition-all transform duration-300 ease-in-out animate-in fade-in scale-[1.15] z-50">
          <.card class="shadow-lg rounded-lg p-6 w-[600px] h-[400px] flex flex-col justify-between transform scale-100 transition-transform duration-300 ease-in-out bg-white">
            <.form for={@form} phx-submit="save_note">
              <.field field={@form[:title]}
                placeholder="Title"
                phx-debounce="blur"
                label=""
                class="!border-none !outline-none !ring-0 !shadow-none"
              />
              <.field field={@form[:content]}
                type="textarea"
                placeholder="Content"
                phx-debounce="blur"
                label=""
                class="!border-none !outline-none !ring-0 !shadow-none"
              />
              <div class="mt-4 flex justify-between">
                <.button label="Save" color="green" />
                <.button label="Cancel" color="red" phx-click="cancel_form" type="button" />
              </div>
            </.form>
          </.card>
        </div>
      <% end %>

      <%= if Map.has_key?(assigns, :note) && @note do %>
        <!-- Pin button as a white circle with icon -->
        <button phx-click="pin_note" phx-value-id={@note.id}
          class={"absolute -right-3 -top-3 w-8 h-8 rounded-full bg-white flex items-center justify-center shadow-md border border-gray-200 hover:bg-gray-100 transition-all duration-300 ease-in-out #{if @show_buttons, do: "opacity-100 translate-x-0", else: "opacity-0 -translate-x-4"}"}>
          <svg width="12" height="18" viewBox="0 0 16 24" fill="none" xmlns="http://www.w3.org/2000/svg"
            class={"#{if @note.pinned, do: "text-black hover:text-black", else: "text-[#171717] hover:text-[#666666]"}"}>
            <path d="M4.00016 1V8.5L1.3335 13.5V16H14.6668V13.5L12.0002 8.5V1M8.00016 16V22.25M2.66683 1H13.3335"
              stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
          </svg>
        </button>

        <!-- Edit button as a white circle with blue icon -->
        <button phx-click="edit_note" phx-value-id={@note.id}
          class={"absolute -right-3 top-7 w-8 h-8 rounded-full bg-white flex items-center justify-center shadow-md border border-gray-200 hover:bg-gray-100 transition-all duration-300 ease-in-out #{if @show_buttons, do: "opacity-100 translate-x-0", else: "opacity-0 -translate-x-4"}"}>
          <HeroiconsV1.Outline.pencil class="w-4 h-4 text-blue-500" />
        </button>

        <!-- Delete button as a white circle with red icon -->
        <button phx-click="delete_note" phx-value-id={@note.id}
          class={"absolute -right-3 top-16 w-8 h-8 rounded-full bg-white flex items-center justify-center shadow-md border border-gray-200 hover:bg-gray-100 transition-all duration-300 ease-in-out #{if @show_buttons, do: "opacity-100 translate-x-0", else: "opacity-0 -translate-x-4"}"}>
          <HeroiconsV1.Outline.trash class="w-4 h-4 text-red-500" />
        </button>

        <!-- Normal note card -->
        <.card class="shadow-lg rounded-lg p-4 w-[260px] h-[260px] flex flex-col justify-between">
          <div class="flex justify-between items-center">
            <div class="flex items-center">
              <%= if @note.pinned do %>
                <button phx-click="pin_note" phx-value-id={@note.id} class="text-red-500 hover:text-red-700 transition-colors mr-1">
                  <svg width="16" height="24" viewBox="0 0 16 24" fill="none" xmlns="http://www.w3.org/2000/svg">
                    <path d="M4.00016 1V8.5L1.3335 13.5V16H14.6668V13.5L12.0002 8.5V1M8.00016 16V22.25M2.66683 1H13.3335" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
                  </svg>
                </button>
              <% end %>
              <h3 class="font-bold text-lg text-left cursor-pointer hover:text-blue-500 transition-colors" phx-click="toggle_read_mode" phx-target={@myself}><%= @note.title %></h3>
            </div>
            <div class="flex items-center space-x-2">
              <.live_component module={NoteTagMenu} id={"note-tag-menu-#{@note.id}"} note={@note} />
              <button phx-click="note_card_options" phx-target={@myself} class="text-gray-500 hover:text-gray-700">
                <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5" viewBox="0 0 20 20" fill="currentColor">
                  <path d="M10 6a2 2 0 110-4 2 2 0 010 4zM10 12a2 2 0 110-4 2 2 0 010 4zM10 18a2 2 0 110-4 2 2 0 010 4z" />
                </svg>
              </button>
            </div>
          </div>

          <p class="text-gray-600 mt-2 line-clamp-3">
            <%= @note.content %>
          </p>
        </.card>
      <% end %>
    </div>
    """
  end

  @impl true
  def mount(socket) do
    {:ok, assign(socket, show_buttons: false)}
  end

  @impl true
  def handle_event("change_color", %{"color" => color}, socket) do
    {:noreply, assign(socket, :selected_color, color)}
  end

  @impl true
  def handle_event("note_card_options", _params, socket) do
    {:noreply, assign(socket, show_buttons: !socket.assigns.show_buttons)}
  end

  @impl true
  def handle_event("toggle_read_mode", _params, socket) do
    send(self(), {:toggle_read_mode, socket.assigns.note})
    {:noreply, socket}
  end
end
