defmodule EvalioAppWeb.HomePage.FilterTagMenu do
  use EvalioAppWeb, :live_component
  import PetalComponents

  def render(assigns) do
    ~H"""
    <div class="relative">
      <div
        id={"filter-tag-menu-#{@id}"}
        class="hidden absolute z-20 mt-2 right-0 w-[120px] bg-white rounded-lg py-2 shadow-lg border border-gray-200 max-h-[200px] overflow-y-auto scrollbar-thin scrollbar-thumb-gray-300 scrollbar-track-gray-100"
      >
        <div class="flex flex-col" role="menu" aria-orientation="vertical">
          <button type="button" phx-click="filter_by_tag" phx-value-tag="red" class="group w-full px-4 py-2 flex items-center space-x-3 hover:bg-[#FF655F] transition-all text-gray-700" role="menuitem">
            <div class="w-3 h-3 rounded-full bg-[#FF655F] transition-all group-hover:w-full group-hover:h-[20px]"></div>
            <span class="text-sm transition-opacity group-hover:opacity-0">Red</span>
          </button>
          <button type="button" phx-click="filter_by_tag" phx-value-tag="orange" class="group w-full px-4 py-2 flex items-center space-x-3 hover:bg-[#FF9F0B] transition-all text-gray-700" role="menuitem">
            <div class="w-3 h-3 rounded-full bg-[#FF9F0B] transition-all group-hover:w-full group-hover:h-[20px]"></div>
            <span class="text-sm transition-opacity group-hover:opacity-0">Orange</span>
          </button>
          <button type="button" phx-click="filter_by_tag" phx-value-tag="yellow" class="group w-full px-4 py-2 flex items-center space-x-3 hover:bg-[#FFD60D] transition-all text-gray-700" role="menuitem">
            <div class="w-3 h-3 rounded-full bg-[#FFD60D] transition-all group-hover:w-full group-hover:h-[20px]"></div>
            <span class="text-sm transition-opacity group-hover:opacity-0">Yellow</span>
          </button>
          <button type="button" phx-click="filter_by_tag" phx-value-tag="green" class="group w-full px-4 py-2 flex items-center space-x-3 hover:bg-[#32D74B] transition-all text-gray-700" role="menuitem">
            <div class="w-3 h-3 rounded-full bg-[#32D74B] transition-all group-hover:w-full group-hover:h-[20px]"></div>
            <span class="text-sm transition-opacity group-hover:opacity-0">Green</span>
          </button>
          <button type="button" phx-click="filter_by_tag" phx-value-tag="blue" class="group w-full px-4 py-2 flex items-center space-x-3 hover:bg-[#02B1FF] transition-all text-gray-700" role="menuitem">
            <div class="w-3 h-3 rounded-full bg-[#02B1FF] transition-all group-hover:w-full group-hover:h-[20px]"></div>
            <span class="text-sm transition-opacity group-hover:opacity-0">Blue</span>
          </button>
          <button type="button" phx-click="filter_by_tag" phx-value-tag="purple" class="group w-full px-4 py-2 flex items-center space-x-3 hover:bg-[#9849E8] transition-all text-gray-700" role="menuitem">
            <div class="w-3 h-3 rounded-full bg-[#9849E8] transition-all group-hover:w-full group-hover:h-[20px]"></div>
            <span class="text-sm transition-opacity group-hover:opacity-0">Purple</span>
          </button>
          <button type="button" phx-click="filter_by_tag" phx-value-tag="none" class="group w-full px-4 py-2 flex items-center space-x-3 hover:bg-[#D9D9D9] transition-all text-gray-700" role="menuitem">
            <div class="w-3 h-3 rounded-full bg-[#D9D9D9] transition-all group-hover:w-full group-hover:h-[20px]"></div>
            <span class="text-sm transition-opacity group-hover:opacity-0">No Tag</span>
          </button>
          <button type="button" phx-click="filter_by_tag" phx-value-tag="all" class="w-full px-4 py-2 text-center text-sm text-[#525252] hover:bg-[#525252] hover:text-[#EAEAEA] transition-colors" role="menuitem">
            Show All
          </button>
        </div>
      </div>
    </div>
    """
  end
end
