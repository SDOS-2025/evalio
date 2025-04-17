defmodule EvalioAppWeb.Components.Note.NoteInput do
  use EvalioAppWeb, :live_component
  use Phoenix.Component
  import Phoenix.LiveView
  import PetalComponents
  

  def render(assigns) do
    ~H"""
    <div id={"note-input-#{@id}"}>
      <!-- Full-screen overlay with blur effect when editing -->
      <div class="fixed inset-0 bg-black/30 backdrop-blur-lg flex items-center justify-center transition-all transform duration-300 ease-in-out animate-in fade-in scale-[1.15] z-50">
        <.card class="shadow-lg rounded-lg p-6 w-[600px] h-[400px] flex flex-col justify-between transform scale-100 transition-transform duration-300 ease-in-out bg-white resize">
          <.form for={@form} phx-submit="save_note" class="h-full flex flex-col">
            <div class="flex-grow">
              <.field field={@form[:title]}
                placeholder="Title"
                phx-debounce="blur"
                label=""
                class="!border-none !outline-none !ring-0 shadow-3xl"
              />
              <.field field={@form[:content]}
                type="textarea"
                placeholder="Content"
                phx-debounce="blur"
                label=""
                class="!border-none !outline-none !ring-0 shadow-3xl h-[217px]"
              />
            </div>
            <div class="flex justify-end space-x-4 absolute bottom-[15px] right-6">
              <.button label="Cancel" color="white" phx-click="cancel_form" type="button" />
              <.button label="Save" color="black" class="px-3 py-2 rounded-md text-m font-medium bg-black text-white hover:bg-gray-700 hover:text-white transition-colors" />
            </div>
          </.form>
        </.card>
      </div>
    </div>
    """
  end
end
