defmodule EvalioAppWeb.Components.Mentors.MentorCard do
  use Phoenix.Component
  import PetalComponents.Avatar

  attr :mentor, :map, required: true

  def mentor_card(assigns) do
    ~H"""
    <div class="bg-white rounded-lg shadow-sm hover:shadow-md border border-gray-200 transition-all duration-300">
      <div class="p-4">
        <div class="flex items-center space-x-4">
          <div class="flex-shrink-0">
            <img
              src={@mentor.profile_picture}
              class="h-16 w-16 rounded-full"
              alt={"Avatar for #{@mentor.first_name}"}
            />
          </div>
          <div class="flex-1 min-w-0">
            <div class="text-base font-medium text-gray-900 truncate">
              {"#{@mentor.first_name} #{@mentor.last_name}"}
              <span class="text-sm text-gray-500 font-normal">({@mentor.pronouns})</span>
            </div>
            <p class="text-sm text-gray-600 mt-1">
              Since {@mentor.year_since}
            </p>
          </div>
        </div>
      </div>
    </div>
    """
  end
end
