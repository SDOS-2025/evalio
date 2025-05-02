defmodule EvalioAppWeb.Components.Mentors.MentorContainer do
  use Phoenix.Component
  alias EvalioAppWeb.Components.Mentors.MentorCard

  attr :mentors, :list, required: true
  attr :class, :string, default: ""

  def mentor_container(assigns) do
    ~H"""
    <div class={["h-[calc(100vh-12rem)] overflow-y-auto", @class]}>
      <div class="grid grid-cols-1 sm:grid-cols-2 md:grid-cols-3 lg:grid-cols-4 gap-6 w-full">
        <%= for mentor <- @mentors do %>
          <div class="w-full mb-4">
            <MentorCard.mentor_card
              first_name={mentor.first_name}
              last_name={mentor.last_name}
              email={mentor.email}
              year_since={mentor.year_since}
              mentee_count={mentor.mentee_count}
            />
          </div>
        <% end %>
      </div>
    </div>
    """
  end
end
