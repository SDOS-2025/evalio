defmodule EvalioAppWeb.Components.Mentees.MenteeCard do
  use Phoenix.Component
  import PetalComponents.Avatar

  attr :mentee, :map, required: true

  def mentee_card(assigns) do
    ~H"""
    <div class="bg-white rounded-lg shadow-sm p-3 hover:shadow-md transition-shadow duration-200">
      <div class="flex items-center space-x-3">
        <div class="flex-shrink-0">
          <img
            src={@mentee.profile_picture}
            class="h-10 w-10 rounded-full"
            alt={"Avatar for #{@mentee.first_name}"}
          />
        </div>
        <div class="flex-1 min-w-0">
          <h3 class="text-sm font-medium text-gray-900 truncate">
            <%= "#{@mentee.first_name} #{@mentee.last_name}" %>
            <span class="text-xs text-gray-500 font-normal">(<%= @mentee.pronouns %>)</span>
          </h3>
          <p class="text-xs text-gray-600">
            <%= @mentee.cohort %>-<%= @mentee.batch %>
          </p>
        </div>
      </div>
    </div>
    """
  end
end
