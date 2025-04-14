defmodule EvalioAppWeb.Components.HomePage.Topbar do
  use Phoenix.Component
  alias EvalioAppWeb.HomePage.SearchBar

  def topbar(assigns) do
    ~H"""
    <div class="bg-black text-white shadow-md">
      <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div class="flex justify-between items-center py-4">
          <div class="flex items-center">
            <div class="flex-shrink-0">
              <h1 class="text-xl font-bold">Evalio</h1>
            </div>
            <div class="ml-4">
              <.live_component module={SearchBar} id="topbar-search" />
            </div>
            <div class="hidden md:block">
              <div class="ml-10 flex items-baseline space-x-4">
                <button class="px-3 py-2 rounded-md text-sm font-medium bg-white text-black hover:bg-black hover:text-white transition-colors">
                  Notes
                </button>
                <button class="px-3 py-2 rounded-md text-sm font-medium bg-black text-white hover:bg-white hover:text-black transition-colors">
                  Mentees
                </button>
                <button class="px-3 py-2 rounded-md text-sm font-medium bg-black text-white hover:bg-white hover:text-black transition-colors">
                  Mentors
                </button>
                <button class="px-3 py-2 rounded-md text-sm font-medium bg-black text-white hover:bg-white hover:text-black transition-colors">
                  Cohorts
                </button>
              </div>
            </div>
          </div>
          <div class="flex items-center">
            <div class="ml-3 relative">
              <div class="flex items-center">
                <span class="text-sm font-medium mr-2">Welcome, User</span>
                <button phx-click="logout" class="px-3 py-1 rounded-md text-sm font-medium text-white bg-gray hover:bg-white hover:text-black">
                  Logout
                </button>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
    """
  end
end
