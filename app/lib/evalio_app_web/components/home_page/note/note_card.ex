defmodule EvalioAppWeb.NoteCard do
  use EvalioAppWeb, :live_component
  use Phoenix.Component
  import Phoenix.LiveView
  import PetalComponents

  alias EvalioAppWeb.NoteTagMenu
  alias EvalioApp.Note

  @impl true
  def handle_event("toggle_preview", _params, socket) do
    {:noreply, assign(socket, show_preview: !socket.assigns.show_preview)}
  end

  def render(assigns) do
    ~H"""
    <div class="relative">
      <%= if @editing do %>
        <!-- Full-screen overlay with blur effect when editing -->
        <div class="fixed inset-0 bg-black/30 backdrop-blur-lg flex items-center justify-center transition-all transform duration-300 ease-in-out animate-in fade-in scale-[1.15] z-50">
          <.card class="shadow-lg rounded-lg p-6 w-[600px] h-[500px] flex flex-col justify-between transform scale-100 transition-transform duration-300 ease-in-out bg-white resize">
            <.form for={@form} phx-submit="save_note" class="h-full flex flex-col">
              <div class="flex-grow">
                <.field
                  field={@form[:title]}
                  placeholder="Title"
                  phx-debounce="blur"
                  label=""
                  class="!border-none !outline-none !ring-0 shadow-3xl"
                />
                <div class="flex justify-end items-center mt-2 mb-1">
                  <button
                    type="button"
                    phx-click="toggle_preview"
                    phx-target={@myself}
                    class="p-2 rounded-full hover:bg-gray-100 transition-colors"
                  >
                    <%= if @show_preview do %>
                      <svg
                        xmlns="http://www.w3.org/2000/svg"
                        fill="none"
                        viewBox="0 0 24 24"
                        stroke-width="1.5"
                        stroke="currentColor"
                        class="w-4 h-4 text-gray-700"
                      >
                        <path
                          stroke-linecap="round"
                          stroke-linejoin="round"
                          d="M3.98 8.223A10.477 10.477 0 0 0 1.934 12C3.226 16.338 7.244 19.5 12 19.5c.993 0 1.953-.138 2.863-.395M6.228 6.228A10.451 10.451 0 0 1 12 4.5c4.756 0 8.773 3.162 10.065 7.498a10.522 10.522 0 0 1-4.293 5.774M6.228 6.228 3 3m3.228 3.228 3.65 3.65m7.894 7.894L21 21m-3.228-3.228-3.65-3.65m0 0a3 3 0 1 0-4.243-4.243m4.242 4.242L9.88 9.88"
                        />
                      </svg>
                    <% else %>
                      <svg
                        xmlns="http://www.w3.org/2000/svg"
                        fill="none"
                        viewBox="0 0 24 24"
                        stroke-width="1.5"
                        stroke="currentColor"
                        class="w-4 h-4 text-gray-500"
                      >
                        <path
                          stroke-linecap="round"
                          stroke-linejoin="round"
                          d="M2.036 12.322a1.012 1.012 0 0 1 0-.639C3.423 7.51 7.36 4.5 12 4.5c4.638 0 8.573 3.007 9.963 7.178.07.207.07.431 0 .639C20.577 16.49 16.64 19.5 12 19.5c-4.638 0-8.573-3.007-9.963-7.178Z"
                        />
                        <path
                          stroke-linecap="round"
                          stroke-linejoin="round"
                          d="M15 12a3 3 0 1 1-6 0 3 3 0 0 1 6 0Z"
                        />
                      </svg>
                    <% end %>
                  </button>
                </div>
                <%= if @show_preview do %>
                  <div class="prose prose-sm max-w-none h-[400px] overflow-y-auto p-4 bg-gray-50 rounded-md">
                    {raw(Earmark.as_html!(@form[:content].value || ""))}
                  </div>
                <% else %>
                  <.field
                    field={@form[:content]}
                    type="textarea"
                    placeholder="Content"
                    phx-debounce="blur"
                    label=""
                    class="!border-none !outline-none !ring-0 shadow-3xl h-[160px] "
                  />
                <% end %>
                <.field type="file" field={@form[:file]} class="mt-1" color="white" />
              </div>
              <div class="flex justify-between items-end mt-2">
                <div class="flex items-center space-x-2 text-sm text-gray-500">
                  <PetalComponents.Icon.icon name="hero-information-circle" class="w-4 h-4" />
                  <span>Use Markdown for formatting</span>
                </div>
                <div class="justify-end flex space-x-4">
                  <.button label="Cancel" color="white" phx-click="cancel_form" type="button" />
                  <.button
                    label="Save"
                    color="black"
                    class="px-3 py-2 rounded-md text-m font-medium bg-black text-white hover:bg-gray-700 hover:text-white transition-colors"
                  />
                </div>
              </div>
            </.form>
          </.card>
        </div>
      <% end %>

      <%= if Map.has_key?(assigns, :note) && @note do %>
        <!-- Pin button as a white circle with icon -->
        <button
          phx-click="pin_note"
          phx-value-id={@note.id}
          phx-target={@myself}
          class={"absolute -right-3 -top-3 w-8 h-8 rounded-full bg-white flex items-center justify-center shadow-md border border-gray-200 hover:bg-gray-100 transition-all duration-300 ease-in-out #{if @show_buttons, do: "opacity-100 translate-x-0", else: "opacity-0 -translate-x-4"}"}
        >
          <svg
            width="12"
            height="18"
            viewBox="0 0 16 24"
            fill="none"
            xmlns="http://www.w3.org/2000/svg"
            class={"#{if @note.pinned, do: "text-black hover:text-black", else: "text-[#171717] hover:text-[#666666]"}"}
          >
            <path
              d="M4.00016 1V8.5L1.3335 13.5V16H14.6668V13.5L12.0002 8.5V1M8.00016 16V22.25M2.66683 1H13.3335"
              stroke="currentColor"
              stroke-width="2"
              stroke-linecap="round"
              stroke-linejoin="round"
            />
          </svg>
        </button>
        <!-- Edit button as a white circle with blue icon -->
        <button
          phx-click="edit_note"
          phx-value-id={@note.id}
          phx-target={@myself}
          class={"absolute -right-3 top-7 w-8 h-8 rounded-full bg-white flex items-center justify-center shadow-md border border-gray-200 hover:bg-gray-100 transition-all duration-300 ease-in-out #{if @show_buttons, do: "opacity-100 translate-x-0", else: "opacity-0 -translate-x-4"}"}
        >
          <HeroiconsV1.Outline.pencil class="w-4 h-4 text-blue-500" />
        </button>
        <!-- Delete button as a white circle with red icon -->
        <button
          phx-click="delete_note"
          phx-value-id={@note.id}
          phx-target={@myself}
          class={"absolute -right-3 top-16 w-8 h-8 rounded-full bg-white flex items-center justify-center shadow-md border border-gray-200 hover:bg-gray-100 transition-all duration-300 ease-in-out #{if @show_buttons, do: "opacity-100 translate-x-0", else: "opacity-0 -translate-x-4"}"}
        >
          <HeroiconsV1.Outline.trash class="w-4 h-4 text-red-500" />
        </button>
        <!-- Normal note card -->
        <.card class="shadow-lg rounded-lg p-4 w-[300px] h-[300px] flex flex-col justify-between">
          <div class="flex justify-between items-center">
            <div class="flex items-center">
              <%= if @note.pinned do %>
                <button
                  phx-click="pin_note"
                  phx-value-id={@note.id}
                  phx-target={@myself}
                  class="text-red-500 hover:text-red-700 transition-colors mr-1"
                >
                  <svg
                    width="16"
                    height="24"
                    viewBox="0 0 16 24"
                    fill="none"
                    xmlns="http://www.w3.org/2000/svg"
                  >
                    <path
                      d="M4.00016 1V8.5L1.3335 13.5V16H14.6668V13.5L12.0002 8.5V1M8.00016 16V22.25M2.66683 1H13.3335"
                      stroke="currentColor"
                      stroke-width="2"
                      stroke-linecap="round"
                      stroke-linejoin="round"
                    />
                  </svg>
                </button>
              <% end %>
              <h3
                class="font-bold text-lg text-left cursor-pointer hover:text-gray-500 transition-colors"
                phx-click="toggle_read_mode"
                phx-target={@myself}
              >
                {@note.title}
              </h3>
            </div>
            <div class="flex items-center space-x-2">
              <.live_component module={NoteTagMenu} id={"note-tag-menu-#{@note.id}"} note={@note} />
              <button
                phx-click="note_card_options"
                phx-target={@myself}
                class="text-gray-500 hover:text-gray-700"
              >
                <svg
                  xmlns="http://www.w3.org/2000/svg"
                  class="h-5 w-5"
                  viewBox="0 0 20 20"
                  fill="currentColor"
                >
                  <path d="M10 6a2 2 0 110-4 2 2 0 010 4zM10 12a2 2 0 110-4 2 2 0 010 4zM10 18a2 2 0 110-4 2 2 0 010 4z" />
                </svg>
              </button>
            </div>
          </div>

          <p class="text-gray-600 mt-2 line-clamp-3">
            <div class="prose prose-sm max-w-none">
              {raw(Earmark.as_html!(@note.content))}
            </div>
          </p>
        </.card>
      <% end %>
    </div>
    """
  end

  @impl true
  def mount(socket) do
    {:ok, assign(socket, show_buttons: false, show_preview: false, current_content: "")}
  end

  @impl true
  def handle_event("change_color", %{"color" => color}, socket) do
    {:noreply, assign(socket, :selected_color, color)}
  end

  @impl true
  def handle_event("update_content", %{"value" => content}, socket) do
    {:noreply, assign(socket, current_content: content)}
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

  @impl true
  def handle_event("pin_note", %{"id" => id}, socket) do
    require Logger
    Logger.info("NoteCard: pin_note event received: id=#{id}")

    # Forward the event to the parent LiveView
    send(self(), {:pin_note, id})

    {:noreply, socket}
  end

  @impl true
  def handle_event("edit_note", %{"id" => id}, socket) do
    require Logger
    Logger.info("NoteCard: edit_note event received: id=#{id}")

    # Forward the event to the parent LiveView
    send(self(), {:edit_note, id})

    {:noreply, socket}
  end

  @impl true
  def handle_event("delete_note", %{"id" => id}, socket) do
    require Logger
    Logger.info("NoteCard: delete_note event received: id=#{id}")

    # Forward the event to the parent LiveView
    send(self(), {:delete_note, id})

    {:noreply, socket}
  end

  @impl true
  def handle_event("change_tag", %{"tag" => tag, "id" => id}, socket) do
    require Logger
    Logger.info("NoteCard: change_tag event received: id=#{id}, tag=#{tag}")

    # Send a message to the parent LiveView (NotesLive)
    send(self(), {:update_note_tag, id, tag})

    {:noreply, socket}
  end

  @impl true
  def update(%{change_tag: {id, tag}} = assigns, socket) do
    require Logger
    Logger.info("NoteCard: change_tag update received: id=#{id}, tag=#{tag}")

    # Send a message to the parent LiveView (NotesLive)
    send(self(), {:update_note_tag, id, tag})

    {:ok, assign(socket, assigns)}
  end

  @impl true
  def update(assigns, socket) do
    {:ok, assign(socket, assigns)}
  end
end
