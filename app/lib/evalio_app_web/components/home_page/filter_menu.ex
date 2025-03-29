defmodule EvalioAppWeb.HomePage.FilterMenu do
  use EvalioAppWeb, :live_component
  import PetalComponents

  def render(assigns) do
    ~H"""
    <div class="relative">
      <button
        type="button"
        class="p-2 rounded-lg hover:bg-gray-100 transition-all cursor-pointer"
        phx-click={JS.toggle(to: "#sort-menu")}
      >
        <PetalComponents.Icon.icon name="hero-funnel" class="w-5 h-5 text-gray-700" />
      </button>

      <div
        id="sort-menu"
        class="hidden absolute z-10 mt-2 w-[160px] bg-[#EAEAEA] rounded-lg shadow-lg"
      >
        <div class="flex flex-col py-1" role="menu" aria-orientation="vertical">
          <button type="button" class="w-full px-4 py-2 text-center text-sm text-[#525252] hover:bg-[#525252] hover:text-[#EAEAEA] transition-colors" role="menuitem">
            Date
          </button>
          <div class="mx-5 border-t-2 border-[#525252]"></div>
          <button type="button" class="w-full px-4 py-2 text-center text-sm text-[#525252] hover:bg-[#525252] hover:text-[#EAEAEA] transition-colors" role="menuitem">
            Type
          </button>
          <div class="mx-5 border-t-2 border-[#525252]"></div>
          <button type="button" class="w-full px-4 py-2 text-center text-sm text-[#525252] hover:bg-[#525252] hover:text-[#EAEAEA] transition-colors" role="menuitem">
            Attachment
          </button>
          <div class="mx-5 border-t-2 border-[#525252]"></div>
          <button type="button" class="w-full px-4 py-2 text-center text-sm text-[#525252] hover:bg-[#525252] hover:text-[#EAEAEA] transition-colors" role="menuitem">
            Tag
          </button>
        </div>
      </div>
    </div>
    """
  end
end
