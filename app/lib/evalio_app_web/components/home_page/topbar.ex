defmodule EvalioAppWeb.Components.HomePage.Topbar do
  use Phoenix.Component
  import Phoenix.LiveView
  alias EvalioAppWeb.HomePage.SearchBar

  def topbar(assigns) do
    ~H"""
    <div class="bg-black text-white shadow-md">
      <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div class="flex justify-between items-center py-4">
          <div class="flex items-center">
            <div class="flex-shrink-0">
              <button
                phx-click="navigate"
                phx-value-to="/notes"
                class="text-3xl font-bold hover:text-gray-300 transition-colors"
              >
                Eval.io
              </button>
            </div>
            <div class="ml-4">
              <.live_component module={SearchBar} id="topbar-search" />
            </div>
            <div class="hidden md:block">
              <div class="ml-10 flex items-baseline space-x-4">
                <button
                  phx-click="navigate"
                  phx-value-to="/notes"
                  class="px-3 py-2 rounded-md text-m font-medium bg-black text-white hover:bg-white hover:text-black transition-colors"
                >
                  Notes
                </button>
                <button
                  phx-click="navigate"
                  phx-value-to="/mentees"
                  class="px-3 py-2 rounded-md text-m font-medium bg-black text-white hover:bg-white hover:text-black transition-colors"
                >
                  Mentees
                </button>
                <button
                  phx-click="navigate"
                  phx-value-to="/mentors"
                  class="px-3 py-2 rounded-md text-m font-medium bg-black text-white hover:bg-white hover:text-black transition-colors"
                >
                  Mentors
                </button>
                <button
                  phx-click="navigate"
                  phx-value-to="/cohorts"
                  class="px-3 py-2 rounded-md text-m font-medium bg-black text-white hover:bg-white hover:text-black transition-colors"
                >
                  Cohorts
                </button>
              </div>
            </div>
          </div>
          <div class="flex items-center">
            <div class="ml-3 relative">
              <div class="flex items-center">
                <span class="text-sm font-medium mr-2">Welcome, User</span>
                <button
                  phx-click="logout"
                  class="px-3 py-1 rounded-md text-sm font-medium text-white bg-gray hover:bg-white hover:text-black"
                >
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
