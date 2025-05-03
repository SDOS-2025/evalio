defmodule EvalioAppWeb.Components.Cohorts.CohortContainer do
  use Phoenix.Component
  alias EvalioAppWeb.Components.Cohorts.CohortCard

  attr :cohorts, :list, required: true
  attr :selected_cohort, :any, default: nil
  attr :class, :string, default: ""

  def cohort_container(assigns) do
    ~H"""
    <div class={["min-h-[calc(100vh-12rem)] p-6 bg-white rounded-lg shadow-sm", @class]}>
      <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 xl:grid-cols-4 gap-6">
        <%= for cohort <- @cohorts do %>
          <div class={[
            "transition-all duration-300 ease-in-out",
            if @selected_cohort && @selected_cohort.id != cohort.id do
              "opacity-0 scale-95 pointer-events-none"
            else
              "opacity-100 scale-100"
            end
          ]}>
            <CohortCard.cohort_card
              name={cohort.name}
              batch={cohort.batch}
              year={cohort.year}
              mentee_count={cohort.mentee_count}
              id={cohort.id}
            />
          </div>
        <% end %>
      </div>
    </div>
    """
  end
end
