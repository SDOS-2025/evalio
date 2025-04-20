# this file needs refactoring

defmodule EvalioAppWeb.Components.Note.NoteInput do
  use EvalioAppWeb, :live_component
  use Phoenix.Component
  import Phoenix.LiveView
  import PetalComponents

  @impl true
  def mount(socket) do
    {:ok, assign(socket, show_preview: false)}
  end

  @impl true
  def handle_event("toggle_preview", _params, socket) do
    {:noreply, assign(socket, show_preview: !socket.assigns.show_preview)}
  end

  def render(assigns) do
    ~H"""
    <div id={"note-input-#{@id}"}>
      <!-- Full-screen overlay with blur effect when editing -->
      <div class="fixed inset-0 bg-black/30 backdrop-blur-lg flex items-center justify-center transition-all transform duration-300 ease-in-out animate-in fade-in scale-[1.15] z-50">
        <.card class="shadow-lg rounded-lg p-6 w-[600px] h-[400px] flex flex-col justify-between transform scale-100 transition-transform duration-300 ease-in-out bg-white resize">
          <.form for={@form} phx-submit="save_note" class="h-full flex flex-col">
            <div class="flex-grow">
              <.field
                field={@form[:title]}
                placeholder="Title"
                phx-debounce="blur"
                label=""
                class="!border-none !outline-none !ring-0 shadow-3xl"
              />
              <div class="flex justify-between items-center mt-2 mb-1">
                <div class="text-sm text-gray-500">
                  Markdown supported
                </div>
                <.button
                  type="button"
                  phx-click="toggle_preview"
                  phx-target={@myself}
                  color="white"
                  size="sm"
                  label={if @show_preview, do: "Edit", else: "Preview"}
                />
              </div>
              <%= if @show_preview do %>
                <div class="prose prose-sm max-w-none h-[400px] overflow-y-auto p-4 bg-gray-50 rounded-md">
                  {raw(Earmark.as_html!(@form[:content].value || ""))}
                </div>
              <% else %>
                <.field
                  field={@form[:content]}
                  type="textarea"
                  placeholder="Content (Markdown supported)
    # Heading 1
    ## Heading 2
    **Bold text**
    *Italic text*
    - List item
    1. Numbered list
    [Link](url)
    ![Image](url)
    ```code block```"
                  phx-debounce="blur"
                  label=""
                  class="!border-none !outline-none !ring-0 shadow-3xl h-[400px] font-mono"
                />
              <% end %>
            </div>
            <div class="flex justify-between mt-4">
              <div class="flex items-center space-x-2 text-sm text-gray-500">
                <PetalComponents.Icon.icon name="hero-information-circle" class="w-4 h-4" />
                <span>Use Markdown for formatting</span>
              </div>
              <div class="flex space-x-4">
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
    </div>
    """
  end
end
