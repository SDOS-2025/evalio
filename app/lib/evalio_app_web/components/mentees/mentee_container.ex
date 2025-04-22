defmodule EvalioAppWeb.Components.Mentees.MenteeContainer do
  use Phoenix.Component
  alias EvalioAppWeb.Components.Mentees.MenteeCard

  attr :mentees, :list, required: true
  attr :class, :string, default: ""

  def mentee_container(assigns) do
    ~H"""
    <div class={["h-[calc(100vh-12rem)] overflow-y-auto", @class]}>
      <div class="columns-1 sm:columns-2 md:columns-3 lg:columns-4 gap-4 w-full">
        <%= for mentee <- @mentees do %>
          <div class="w-full break-inside-avoid mb-4">
            <MenteeCard.mentee_card mentee={mentee} expanded={mentee.is_expanded} />
          </div>
        <% end %>
      </div>
    </div>
    """
  end
end
