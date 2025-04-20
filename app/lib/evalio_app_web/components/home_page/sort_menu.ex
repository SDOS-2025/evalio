defmodule EvalioAppWeb.HomePage.SortMenu do
  use EvalioAppWeb, :live_component
  import PetalComponents

  def render(assigns) do
    ~H"""
    <div class="relative">
      <button
        type="button"
        class="w-[50px] h-[50px] rounded-lg bg-[#FFFFFF] hover:bg-[#171717] transition-all cursor-pointer flex items-center justify-center group"
        phx-click={JS.toggle(to: "#sort-menu")}
      >
        <svg
          class="w-[30px] h-[30px] text-[#171717] group-hover:text-[#FFFFFF] transition-colors"
          viewBox="0 0 24 24"
          xmlns="http://www.w3.org/2000/svg"
        >
          <path fill="currentColor" d="M8 16H4l6 6V2H8zm6-11v17h2V8h4l-6-6z" />
        </svg>
      </button>

      <div
        id="sort-menu"
        class="hidden absolute z-10 mt-2 w-[160px] bg-[#FFFFFF] rounded-lg shadow-lg border border-gray-200"
      >
        <div class="flex flex-col py-1" role="menu" aria-orientation="vertical">
          <button
            type="button"
            phx-click="sort_notes"
            phx-value-sort="newest_first"
            class="w-full px-4 py-2 text-center text-sm text-[#1C1C1E] hover:bg-[#1C1C1E] hover:text-[#FFFFFF] transition-colors"
            role="menuitem"
          >
            Newest to Oldest
          </button>
          <div class="mx-5 border-t-2 border-[#1C1C1E]"></div>
          <button
            type="button"
            phx-click="sort_notes"
            phx-value-sort="oldest_first"
            class="w-full px-4 py-2 text-center text-sm text-[#1C1C1E] hover:bg-[#1C1C1E] hover:text-[#FFFFFF] transition-colors"
            role="menuitem"
          >
            Oldest to Newest
          </button>
          <div class="mx-5 border-t-2 border-[#1C1C1E]"></div>
          <button
            type="button"
            phx-click="sort_notes"
            phx-value-sort="last_edited"
            class="w-full px-4 py-2 text-center text-sm text-[#1C1C1E] hover:bg-[#1C1C1E] hover:text-[#FFFFFF] transition-colors"
            role="menuitem"
          >
            Last Edited
          </button>
          <div class="mx-5 border-t-2 border-[#1C1C1E]"></div>
          <button
            type="button"
            phx-click="sort_notes"
            phx-value-sort="title_asc"
            class="w-full px-4 py-2 text-center text-sm text-[#1C1C1E] hover:bg-[#1C1C1E] hover:text-[#FFFFFF] transition-colors"
            role="menuitem"
          >
            Title A-Z
          </button>
          <div class="mx-5 border-t-2 border-[#1C1C1E]"></div>
          <button
            type="button"
            phx-click="sort_notes"
            phx-value-sort="title_desc"
            class="w-full px-4 py-2 text-center text-sm text-[#1C1C1E] hover:bg-[#1C1C1E] hover:text-[#FFFFFF] transition-colors"
            role="menuitem"
          >
            Title Z-A
          </button>
        </div>
      </div>
    </div>
    """
  end
end
