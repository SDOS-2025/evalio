defmodule EvalioAppWeb.Components.Cohorts.CohortContainer do
  use Phoenix.Component
  alias EvalioAppWeb.Components.Cohorts.CohortCard

  attr :cohorts, :list, required: true
  attr :class, :string, default: ""

  def cohort_container(assigns) do
    ~H"""
    <div class={["h-[calc(100vh-12rem)] overflow-y-auto bg-gray-500", @class]}>
      <div class="grid grid-cols-1 sm:grid-cols-2 md:grid-cols-2 lg:grid-cols-2 gap-6 w-full">
        <%= for cohort <- @cohorts do %>
          <div class="w-full mb-4">
            <CohortCard.cohort_card
              type={cohort.type}
              batch={cohort.batch}
              year={cohort.year}
              mentee_count={cohort.mentee_count}
            />
          </div>
        <% end %>
      </div>
    </div>
    """
  end
end
