defmodule EvalioAppWeb.NoteCard do
  use EvalioAppWeb, :live_component
  import PetalComponents
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

end
