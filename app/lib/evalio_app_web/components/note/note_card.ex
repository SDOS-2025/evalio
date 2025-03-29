defmodule EvalioAppWeb.NoteCard do
  use EvalioAppWeb, :live_component
  import PetalComponents

  alias EvalioAppWeb.NoteTagMenu
  def render(assigns) do
    ~H"""
    <div>
      <.card class="shadow-lg rounded-lg p-4 w-[260px] h-[260px] flex flex-col justify-between">
        <div class="flex justify-between items-center">
          <h3 class="font-bold text-lg"><%= @note.title %></h3>
          <div class="flex items-center space-x-2">

          <.live_component module={NoteTagMenu} id={"note-tag-menu-#{@note.id}"} note={@note} />
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
        <.card class="shadow-lg rounded-lg p-4 w-[260px] h-[260px] flex flex-col">
          <.card_content heading={@note.title} class="flex flex-col h-full">
            <div class="flex-grow">
              <p><%= @note.content %></p>
            </div>
            <div class="flex justify-end gap-4 mt-auto">
              <button phx-click="edit_note" phx-value-id={@note.id} class="text-blue-500">
                <HeroiconsV1.Outline.pencil class="w-7 h-7 cursor-pointer" />
              </button>
              <button phx-click="delete_note" phx-value-id={@note.id} class="text-red-500">
                <HeroiconsV1.Outline.trash class="w-7 h-7 cursor-pointer" />
              </button>
            </div>
          </.card_content>
        </.card>
      <% end %>
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
