defmodule EvalioAppWeb.Components.Mentees.MenteeCard do
  use Phoenix.Component
  import PetalComponents.Avatar

  attr :mentee, :map, required: true
  attr :expanded, :boolean, default: false

  def mentee_card(assigns) do
    ~H"""
    <div class="bg-white rounded-lg shadow-sm hover:shadow-md transition-all duration-300 cursor-pointer">
      <%= if @expanded do %>
        <div class="p-4">
          <div class="flex items-center space-x-4">
            <div class="flex-shrink-0">
              <img
                src={@mentee.profile_picture}
                class="h-16 w-16 rounded-full"
                alt={"Avatar for #{@mentee.first_name}"}
              />
            </div>
            <div class="flex-1 min-w-0">
              <h3 class="text-base font-medium text-gray-900 truncate">
                <%= "#{@mentee.first_name} #{@mentee.last_name}" %>
                <span class="text-sm text-gray-500 font-normal">(<%= @mentee.pronouns %>)</span>
              </h3>
              <p class="text-sm text-gray-600 mt-1">
                <%= @mentee.cohort %>-<%= @mentee.batch %>
              </p>
              <div class="flex items-center mt-1">
                <span class="text-sm text-gray-600"><%= @mentee.email %></span>
              </div>
            </div>
          </div>
        </div>

        <div class="p-4 space-y-4 bg-gray-50 border-t">
          <div class="grid grid-cols-2 gap-4">
            <div class="relative">
              <div class="flex items-center justify-center">
                <svg class="w-24 h-24 transform -rotate-90">
                  <circle
                    class="text-gray-200"
                    stroke-width="8"
                    stroke="currentColor"
                    fill="transparent"
                    r="40"
                    cx="48"
                    cy="48"
                  />
                  <circle
                    class="text-green-500"
                    stroke-width="8"
                    stroke="currentColor"
                    fill="transparent"
                    r="40"
                    cx="48"
                    cy="48"
                    stroke-dasharray={2 * :math.pi() * 40}
                    stroke-dashoffset={2 * :math.pi() * 40 * (1 - @mentee.attendance_percent / 100)}
                  />
                </svg>
                <span class="absolute text-xl font-semibold text-gray-700"><%= @mentee.attendance_percent %>%</span>
              </div>
              <p class="text-center mt-2 text-sm font-medium text-gray-600">Attendance</p>
            </div>

            <div class="relative">
              <div class="flex items-center justify-center">
                <svg class="w-24 h-24 transform -rotate-90">
                  <circle
                    class="text-gray-200"
                    stroke-width="8"
                    stroke="currentColor"
                    fill="transparent"
                    r="40"
                    cx="48"
                    cy="48"
                  />
                  <circle
                    class="text-green-500"
                    stroke-width="8"
                    stroke="currentColor"
                    fill="transparent"
                    r="40"
                    cx="48"
                    cy="48"
                    stroke-dasharray={2 * :math.pi() * 40}
                    stroke-dashoffset={2 * :math.pi() * 40 * (1 - @mentee.assignment_percent / 100)}
                  />
                </svg>
                <span class="absolute text-xl font-semibold text-gray-700"><%= @mentee.assignment_percent %>%</span>
              </div>
              <p class="text-center mt-2 text-sm font-medium text-gray-600">Assignment</p>
            </div>
          </div>
        </div>
      <% else %>
        <div class="p-4">
          <div class="flex items-center space-x-4">
            <div class="flex-shrink-0">
              <img
                src={@mentee.profile_picture}
                class="h-12 w-12 rounded-full"
                alt={"Avatar for #{@mentee.first_name}"}
              />
            </div>
            <div class="flex-1 min-w-0">
              <h3 class="text-base font-medium text-gray-900 truncate">
                <%= "#{@mentee.first_name} #{@mentee.last_name}" %>
              </h3>
              <p class="text-sm text-gray-600 mt-1">
                <%= @mentee.cohort %>-<%= @mentee.batch %>
              </p>
            </div>
          </div>
        </div>
      <% end %>
    </div>
    """
  end
end
