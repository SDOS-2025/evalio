defmodule EvalioAppWeb.Components.Mentees.MenteeContainer do
  use Phoenix.Component
  alias EvalioAppWeb.Components.Mentees.MenteeCard

  attr :mentees, :list, required: true
  attr :class, :string, default: ""

  def mentee_container(assigns) do
    ~H"""
    <div class={["grid grid-cols-1 sm:grid-cols-2 md:grid-cols-3 lg:grid-cols-4 xl:grid-cols-5 2xl:grid-cols-6 gap-4", @class]}>
      <%= for mentee <- @mentees do %>
        <MenteeCard.mentee_card mentee={mentee} />
      <% end %>
    </div>
    """
  end
end
