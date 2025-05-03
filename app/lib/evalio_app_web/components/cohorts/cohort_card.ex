defmodule EvalioAppWeb.Components.Cohorts.CohortCard do
  use Phoenix.Component

  attr :name, :string, required: true
  attr :batch, :string, required: true
  attr :year, :integer, required: true
  attr :mentee_count, :integer, required: true
  attr :id, :integer, required: true

  def cohort_card(assigns) do
    ~H"""
    <div class="bg-white rounded-xl p-6 flex flex-col justify-between h-40 border border-gray-200 hover:border-blue-500 hover:shadow-md transition-all duration-200">
      <div class="flex justify-between items-start">
        <div>
          <button
            class="focus:outline-none group"
            phx-click="open_cohort_modal"
            phx-value-cohort={@id}
          >
            <div class="text-xl font-semibold text-gray-800 group-hover:text-blue-600 transition-colors duration-200">
              {@name} <span class="text-gray-500">-</span> <span class="font-mono">{@batch}</span>
            </div>
          </button>
        </div>
        <div class="text-lg text-gray-500 font-medium">{@year}</div>
      </div>
      <div class="mt-4 flex items-center text-gray-600">
        <svg
          xmlns="http://www.w3.org/2000/svg"
          class="h-5 w-5 mr-2"
          viewBox="0 0 20 20"
          fill="currentColor"
        >
          <path d="M13 6a3 3 0 11-6 0 3 3 0 016 0zM18 8a2 2 0 11-4 0 2 2 0 014 0zM14 15a4 4 0 00-8 0v3h8v-3zM6 8a2 2 0 11-4 0 2 2 0 014 0zM16 18v-3a5.972 5.972 0 00-.75-2.906A3.005 3.005 0 0119 15v3h-3zM4.75 12.094A5.973 5.973 0 004 15v3H1v-3a3 3 0 013.75-2.906z" />
        </svg>
        <span class="text-lg">{@mentee_count} Mentees</span>
      </div>
    </div>
    """
  end
end
