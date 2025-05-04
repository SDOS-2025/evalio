defmodule EvalioAppWeb.Components.HomePage.Topbar do
  use Phoenix.Component
  import Phoenix.LiveView
  alias EvalioAppWeb.HomePage.SearchBar
  alias EvalioAppWeb.ReminderContainer
  alias EvalioAppWeb.MeetingContainer
  alias EvalioAppWeb.CalendarComponent

  attr :show_reminder, :boolean, default: false
  attr :show_meeting, :boolean, default: false
  attr :show_calendar, :boolean, default: false
  attr :reminders, :list, default: []
  attr :meetings, :list, default: []
  attr :current_user, :any, default: nil

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
                <button
                  phx-click="navigate"
                  phx-value-to="/sessions"
                  class="px-3 py-2 rounded-md text-m font-medium bg-black text-white hover:bg-white hover:text-black transition-colors"
                >
                  Sessions
                </button>
              </div>
            </div>
          </div>
          <div class="flex items-center">
            <div class="ml-3 relative">
              <div class="flex items-center space-x-4">
                <span class="text-sm font-medium text-white">Welcome, User</span>
                <button
                  phx-click="logout"
                  class="px-3 py-1 rounded-md text-sm font-medium text-white bg-gray hover:bg-white hover:text-black"
                >
                  Logout
                </button>
              </div>
              <!-- Hanging Buttons -->
              <div class="absolute right-0 top-full mt-5 flex space-x-2 z-50">
                <button
                  phx-click="toggle_calendar"
                  class="px-3 py-1 rounded-md text-sm font-medium bg-black text-white hover:bg-white hover:text-black shadow-md"
                >
                  Calendar
                </button>
                <button
                  phx-click="toggle_reminder"
                  class="px-3 py-1 rounded-md text-sm font-medium bg-black text-white hover:bg-white hover:text-black shadow-md"
                >
                  Reminders
                </button>
                <button
                  phx-click="toggle_meeting"
                  class="px-3 py-1 rounded-md text-sm font-medium bg-black text-white hover:bg-white hover:text-black shadow-md"
                >
                  Meetings
                </button>
              </div>
              <!-- Calendar Container -->
              <%= if @show_calendar do %>
                <div class="absolute right-0 top-full mt-16 w-96 bg-white rounded-lg shadow-lg z-50">
                  <.live_component
                    module={CalendarComponent}
                    id="calendar"
                    reminders={@reminders}
                    meetings={@meetings}
                  />
                </div>
              <% end %>
              <!-- Reminder Container -->
              <%= if @show_reminder do %>
                <div class="absolute right-0 top-full mt-16 w-96 bg-white rounded-lg shadow-lg z-50">
                  <.live_component
                    module={ReminderContainer}
                    id="reminder-container"
                    reminders={@reminders}
                  />
                </div>
              <% end %>
              <!-- Meeting Container -->
              <%= if @show_meeting do %>
                <div class="absolute right-0 top-full mt-16 w-96 bg-white rounded-lg shadow-lg z-50">
                  <.live_component
                    module={MeetingContainer}
                    id="meeting-container"
                    meetings={@meetings}
                    current_user={@current_user}
                  />
                </div>
              <% end %>
            </div>
          </div>
        </div>
      </div>
    </div>
    """
  end
end
