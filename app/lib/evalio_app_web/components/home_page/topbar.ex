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
                <span class="px-3 py-2 rounded-md text-sm font-medium bg-gray text-white">
                  Notes
                </span>
                <span class="px-3 py-2 rounded-md text-sm font-medium text-gray-300">
                  Mentees
                </span>
                <span class="px-3 py-2 rounded-md text-sm font-medium text-gray-300">
                  Mentors
                </span>
                <span class="px-3 py-2 rounded-md text-sm font-medium text-gray-300">
                  Cohorts
                </span>
              </div>
            </div>
          </div>
          <div class="flex items-center">
            <div class="ml-3 relative">
              <div class="flex items-center">
                <span class="text-sm font-medium mr-2">Welcome, User</span>
                <button phx-click="logout" class="px-3 py-1 rounded-md text-sm font-medium text-white bg-gray hover:bg-blue-600">
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
