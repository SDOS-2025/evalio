defmodule EvalioAppWeb.HomePage.FilterTypeMenu do
  use EvalioAppWeb, :live_component
  import PetalComponents

  def render(assigns) do
    ~H"""
    <div class="relative">
      <div
        id={"filter-type-menu-#{@id}"}
        class="hidden absolute z-20 right-full ml-2 w-[160px] bg-[#FFFFFF] rounded-lg shadow-lg border border-gray-200"
      >
        <div class="flex flex-col py-1" role="menu" aria-orientation="vertical">
          <button type="button" phx-click="filter_by_type" phx-value-type="todo" class="w-full px-4 py-2 text-center text-sm text-[#1C1C1E] hover:bg-[#1C1C1E] hover:text-[#FFFFFF] transition-colors" role="menuitem">
            To-Do
          </button>
          <div class="mx-5 border-t-2 border-[#1C1C1E]"></div>
          <button type="button" phx-click="filter_by_type" phx-value-type="checklist" class="w-full px-4 py-2 text-center text-sm text-[#1C1C1E] hover:bg-[#1C1C1E] hover:text-[#FFFFFF] transition-colors" role="menuitem">
            Checklist
          </button>
          <div class="mx-5 border-t-2 border-[#1C1C1E]"></div>
          <button type="button" phx-click="filter_by_type" phx-value-type="meeting" class="w-full px-4 py-2 text-center text-sm text-[#1C1C1E] hover:bg-[#1C1C1E] hover:text-[#FFFFFF] transition-colors" role="menuitem">
            Meeting
          </button>
          <div class="mx-5 border-t-2 border-[#1C1C1E]"></div>
          <button type="button" phx-click="filter_by_type" phx-value-type="student_mentions" class="w-full px-4 py-2 text-center text-sm text-[#1C1C1E] hover:bg-[#1C1C1E] hover:text-[#FFFFFF] transition-colors" role="menuitem">
            Student Mentions
          </button>
          <div class="mx-5 border-t-2 border-[#1C1C1E]"></div>
          <button type="button" phx-click="filter_by_type" phx-value-type="mentor_mentions" class="w-full px-4 py-2 text-center text-sm text-[#1C1C1E] hover:bg-[#1C1C1E] hover:text-[#FFFFFF] transition-colors" role="menuitem">
            Mentor Mentions
          </button>
          <div class="mx-5 border-t-2 border-[#1C1C1E]"></div>
          <button type="button" phx-click="filter_by_type" phx-value-type="cohort_mentions" class="w-full px-4 py-2 text-center text-sm text-[#1C1C1E] hover:bg-[#1C1C1E] hover:text-[#FFFFFF] transition-colors" role="menuitem">
            Cohort Mentions
          </button>
          <div class="mx-5 border-t-2 border-[#1C1C1E]"></div>
          <button type="button" phx-click="filter_by_type" phx-value-type="hyperlinked" class="w-full px-4 py-2 text-center text-sm text-[#1C1C1E] hover:bg-[#1C1C1E] hover:text-[#FFFFFF] transition-colors" role="menuitem">
            Hyperlinked
          </button>
        </div>
      </div>
    </div>
    """
  end
end
