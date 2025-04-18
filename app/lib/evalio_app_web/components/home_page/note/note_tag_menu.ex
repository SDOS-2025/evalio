defmodule EvalioAppWeb.NoteTagMenu do
  use EvalioAppWeb, :live_component
  import PetalComponents

  def render(assigns) do
    ~H"""
    <div class="relative">
      <button
        type="button"
        class={"w-[60px] h-[30px] #{tag_color_class(@note.tag)} text-white text-sm flex items-center justify-center rounded-full cursor-pointer hover:#{tag_color_class(@note.tag)} transition-all outline-none"}
        phx-click={JS.toggle(to: "#dropdown-menu-#{@note.id}")}
      >
      </button>

      <div
        id={"dropdown-menu-#{@note.id}"}
        class="hidden absolute z-10 mt-2 right-0 w-[120px] bg-white rounded-lg py-2 shadow-lg border border-gray-200 max-h-[200px] overflow-y-auto scrollbar-thin scrollbar-thumb-gray-300 scrollbar-track-gray-100"
      >
        <div class="flex flex-col" role="menu" aria-orientation="vertical">
          <button type="button" phx-click="change_tag" phx-value-tag="urgent" phx-value-id={@note.id} phx-target={@myself} class="group w-full px-4 py-2 flex items-center space-x-3 hover:bg-[#FF655F] transition-all text-gray-700" role="menuitem">
            <div class="w-3 h-3 rounded-full bg-[#FF655F] transition-all group-hover:w-full group-hover:h-[20px]"></div>
            <span class="text-sm transition-opacity group-hover:opacity-0">Urgent</span>
          </button>

          <button type="button" phx-click="change_tag" phx-value-tag="at risk" phx-value-id={@note.id} phx-target={@myself} class="group w-full px-4 py-2 flex items-center space-x-3 hover:bg-[#FFD60D] transition-all text-gray-700" role="menuitem">
            <div class="w-3 h-3 rounded-full bg-[#FFD60D] transition-all group-hover:w-full group-hover:h-[20px]"></div>
            <span class="text-sm transition-opacity group-hover:opacity-0">At Risk</span>
          </button>
          <button type="button" phx-click="change_tag" phx-value-tag="on track" phx-value-id={@note.id} phx-target={@myself} class="group w-full px-4 py-2 flex items-center space-x-3 hover:bg-[#32D74B] transition-all text-gray-700" role="menuitem">
            <div class="w-3 h-3 rounded-full bg-[#32D74B] transition-all group-hover:w-full group-hover:h-[20px]"></div>
            <span class="text-sm transition-opacity group-hover:opacity-0">On Track</span>
          </button>

          <button type="button" phx-click="change_tag" phx-value-tag="none" phx-value-id={@note.id} phx-target={@myself} class="group w-full px-4 py-2 flex items-center space-x-3 hover:bg-[#D9D9D9] transition-all text-gray-700" role="menuitem">
            <div class="w-3 h-3 rounded-full bg-[#D9D9D9] transition-all group-hover:w-full group-hover:h-[20px]"></div>
            <span class="text-sm transition-opacity group-hover:opacity-0">No Tag</span>
          </button>
        </div>
      </div>
    </div>
    """
  end

  defp tag_color_class(tag) do
    case tag do
      "urgent" -> "bg-[#FF655F]"
      "orange" -> "bg-[#FF9F0B]"
      "at risk" -> "bg-[#FFD60D]"
      "on track" -> "bg-[#32D74B]"
      "blue" -> "bg-[#02B1FF]"
      "purple" -> "bg-[#9849E8]"
      _ -> "bg-[#D9D9D9]"
    end
  end

  @impl true
  def handle_event("change_tag", %{"tag" => tag, "id" => id}, socket) do
    send(self(), {:update_note_tag, id, tag})
    {:noreply, socket}
  end
end
