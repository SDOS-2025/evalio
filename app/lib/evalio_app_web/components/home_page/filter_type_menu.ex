defmodule EvalioAppWeb.HomePage.FilterTypeMenu do
  use EvalioAppWeb, :live_component
  import PetalComponents

  def render(assigns) do
    ~H"""
    <div class="relative">
      <div
        id={"filter-type-menu-#{@id}"}
        class="hidden absolute z-20 right-full ml-2 w-[160px] bg-[#EAEAEA] rounded-lg shadow-lg"
      >
        <div class="flex flex-col py-1" role="menu" aria-orientation="vertical">
          <button type="button" class="w-full px-4 py-2 text-center text-sm text-[#525252] hover:bg-[#525252] hover:text-[#EAEAEA] transition-colors" role="menuitem">
            Text Note
          </button>
          <div class="mx-5 border-t-2 border-[#525252]"></div>
          <button type="button" class="w-full px-4 py-2 text-center text-sm text-[#525252] hover:bg-[#525252] hover:text-[#EAEAEA] transition-colors" role="menuitem">
            Code Snippet
          </button>
          <div class="mx-5 border-t-2 border-[#525252]"></div>
          <button type="button" class="w-full px-4 py-2 text-center text-sm text-[#525252] hover:bg-[#525252] hover:text-[#EAEAEA] transition-colors" role="menuitem">
            Image Note
          </button>
        </div>
      </div>
    </div>
    """
  end
end
