defmodule EvalioAppWeb.HomePage.FilterMenu do
  use EvalioAppWeb, :live_component
  import PetalComponents
  alias EvalioAppWeb.HomePage.FilterTypeMenu
  alias EvalioAppWeb.HomePage.FilterTagMenu

  def render(assigns) do
    ~H"""
    <div class="relative">
      <button
        type="button"
        class="w-[50px] h-[50px] rounded-lg bg-[#FFFFFF] hover:bg-[#171717] transition-all cursor-pointer flex items-center justify-center group"
        phx-click={JS.toggle(to: "#filter-menu-#{@id}")}
      >
        <svg
          class="w-[30px] h-[30px] text-[#171717] group-hover:text-[#FFFFFF] transition-colors"
          viewBox="0 0 34 42"
          xmlns="http://www.w3.org/2000/svg"
        >
          <path
            fill="currentColor"
            fill-rule="evenodd"
            clip-rule="evenodd"
            d="M19.5148 21.8996L28.388 9.95438H5.41482L14.2881 21.8996H19.5148ZM18.5916 25.8814H15.2113V35.9492L18.5916 34.4561V25.8814ZM3.38028 5.97263H30.4225V3.98175H3.38028V5.97263ZM11.831 24.6386L0 8.71155V3.98175C0 1.78269 1.5134 0 3.38028 0H30.4225C32.2894 0 33.8028 1.78269 33.8028 3.98175V8.71155L21.9718 24.6386V37.2154L11.831 41.6949V24.6386Z"
          />
        </svg>
      </button>

      <div
        id={"filter-menu-#{@id}"}
        class="hidden absolute right-0 z-10 mt-2 w-[160px] bg-[#FFFFFF] rounded-lg shadow-lg border border-gray-200"
      >
        <div class="flex flex-col py-1" role="menu" aria-orientation="vertical">
          <button
            type="button"
            class="w-full px-4 py-2 text-center text-sm text-[#1C1C1E] hover:bg-[#1C1C1E] hover:text-[#FFFFFF] transition-colors"
            role="menuitem"
          >
            Date
          </button>
          <div class="mx-5 border-t-2 border-[#1C1C1E]"></div>
          <div class="relative">
            <button
              type="button"
              class="w-full px-4 py-2 text-center text-sm text-[#1C1C1E] hover:bg-[#1C1C1E] hover:text-[#FFFFFF] transition-colors"
              role="menuitem"
              phx-click={JS.toggle(to: "#filter-type-menu-filter-type-#{@id}")}
            >
              Type
            </button>
            <.live_component module={FilterTypeMenu} id={"filter-type-#{@id}"} />
          </div>
          <div class="mx-5 border-t-2 border-[#1C1C1E]"></div>
          <button
            type="button"
            class="w-full px-4 py-2 text-center text-sm text-[#1C1C1E] hover:bg-[#1C1C1E] hover:text-[#FFFFFF] transition-colors"
            role="menuitem"
          >
            Attachment
          </button>
          <div class="mx-5 border-t-2 border-[#1C1C1E]"></div>
          <div class="relative">
            <button
              type="button"
              class="w-full px-4 py-2 text-center text-sm text-[#1C1C1E] hover:bg-[#1C1C1E] hover:text-[#FFFFFF] transition-colors"
              role="menuitem"
              phx-click={JS.toggle(to: "#filter-tag-menu-filter-tag-#{@id}")}
            >
              Tag
            </button>
            <.live_component module={FilterTagMenu} id={"filter-tag-#{@id}"} />
          </div>
        </div>
      </div>
    </div>
    """
  end
end
