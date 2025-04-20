defmodule EvalioAppWeb.Components.Mentees.MenteeContainer do
  use Phoenix.Component
  alias EvalioAppWeb.Components.Mentees.MenteeCard

  attr :mentees, :list, required: true
  attr :class, :string, default: ""

  def mentee_container(assigns) do
    ~H"""
    <div class={["grid grid-cols-1 sm:grid-cols-2 gap-6 w-full", @class]}>
      <%= for mentee <- @mentees do %>
        <div class="w-full">
          <MenteeCard.mentee_card mentee={mentee} expanded={mentee.is_expanded} />
        </div>
      <% end %>
    </div>
    """
  end
end
