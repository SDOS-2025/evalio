defmodule EvalioAppWeb.NoteCard do
  use EvalioAppWeb, :live_component
  import PetalComponents

  alias EvalioAppWeb.NoteTagMenu
  alias EvalioApp.Note

  def render(assigns) do
    ~H"""
    <div>
      <%= if @editing do %>
        <!-- Full-screen overlay with blur effect when editing -->
        <div class="fixed inset-0 bg-black/30 backdrop-blur-lg flex items-center justify-center transition-all transform duration-300 ease-in-out animate-in fade-in scale-[1.15]">
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
      <% else %>
        <!-- Normal note card -->
        <.card class="shadow-lg rounded-lg p-4 w-[260px] h-[260px] flex flex-col justify-between">
          <div class="flex justify-between items-center">
            <button phx-click="pin_note" phx-value-id={@note.id} class={
              "transition-colors #{if @note.pinned, do: "text-red-500 hover:text-red-700", else: "text-[#171717] hover:text-[#666666]"}"
            }>
              <svg width="16" height="24" viewBox="0 0 16 24" fill="none" xmlns="http://www.w3.org/2000/svg">
                <path d="M4.00016 1V8.5L1.3335 13.5V16H14.6668V13.5L12.0002 8.5V1M8.00016 16V22.25M2.66683 1H13.3335" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
              </svg>
            </button>
            <h3 class="font-bold text-lg"><%= @note.title %></h3>
            <div class="flex items-center space-x-2">
              <.live_component module={NoteTagMenu} id={"note-tag-menu-#{@note.id}"} note={@note} />
              <button phx-click="edit_note" phx-value-id={@note.id} class="text-blue-500">
                <HeroiconsV1.Outline.pencil class="w-5 h-5 cursor-pointer" />
              </button>
              <button phx-click="delete_note" phx-value-id={@note.id} class="text-red-500">
                <HeroiconsV1.Outline.trash class="w-5 h-5 cursor-pointer" />
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
  def handle_event("change_color", %{"color" => color}, socket) do
    {:noreply, assign(socket, :selected_color, color)}
  end
end
