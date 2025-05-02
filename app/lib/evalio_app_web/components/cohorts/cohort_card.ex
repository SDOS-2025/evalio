defmodule EvalioAppWeb.Components.Cohorts.CohortCard do
  use Phoenix.Component

  attr :type, :string, required: true
  attr :batch, :string, required: true
  attr :year, :string, required: true
  attr :mentee_count, :integer, required: true

  def cohort_card(assigns) do
    ~H"""
    <div class="bg-gray-100 rounded-xl p-6 flex flex-col justify-between w-80 h-32 shadow-sm">
      <div class="flex justify-between items-start">
        <div>
          <button class="focus:outline-none">
            <div class="text-2xl font-mono font-semibold text-black">
              <%= "{" %>{@type}-{@batch}<%= "}" %>
            </div>
          </button>
        </div>
        <div class="text-xl text-gray-500 font-light">{@year}</div>
      </div>
      <div class="mt-4 text-gray-500 text-lg">Mentees: {@mentee_count}</div>
    </div>
    """
  end
end
