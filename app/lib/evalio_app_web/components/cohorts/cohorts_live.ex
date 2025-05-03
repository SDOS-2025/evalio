defmodule EvalioAppWeb.CohortsLive do
  use EvalioAppWeb, :live_view
  import EvalioAppWeb.CoreComponents
  import PetalComponents

  alias EvalioAppWeb.Components.HomePage.Topbar
  alias EvalioAppWeb.Components.Cohorts.CohortCard
  alias EvalioAppWeb.Components.Cohorts.CohortContainer
  alias EvalioApp.Cohort

  @impl true
  def mount(_params, _session, socket) do
    cohorts = Cohort.list_cohorts()

    {:ok,
     assign(socket,
       cohorts: cohorts,
       search_text: "",
       sort_by: "name_asc",
       selected_cohort: nil
     )}
  end

  @impl true
  def handle_event("sort_cohorts", %{"sort" => sort_option}, socket) do
    {:noreply, assign(socket, sort_by: sort_option)}
  end

  @impl true
  def handle_info({:search_cohorts, search_text}, socket) do
    {:noreply, assign(socket, search_text: search_text)}
  end

  @impl true
  def handle_event("navigate", %{"to" => path}, socket) do
    {:noreply, push_navigate(socket, to: path)}
  end

  @impl true
  def handle_event("logout", _params, socket) do
    {:noreply, push_navigate(socket, to: "/login")}
  end

  @impl true
  def handle_event("open_cohort_modal", %{"cohort" => cohort_id}, socket) do
    cohort_id = String.to_integer(cohort_id)

    selected_cohort =
      if socket.assigns.selected_cohort && socket.assigns.selected_cohort.id == cohort_id do
        nil
      else
        Enum.find(socket.assigns.cohorts, &(&1.id == cohort_id))
      end

    {:noreply, assign(socket, selected_cohort: selected_cohort)}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div class="min-h-screen">
      <div class="fixed top-0 left-0 right-0 z-50">
        <Topbar.topbar />
      </div>

      <div class="fixed left-0 top-0 pt-16 px-4 sm:px-6 lg:px-8 w-full">
        <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
          <div class="py-8">
            <h1 class="text-3xl font-bold text-gray-900">Cohorts</h1>
            <p class="mt-2 text-sm text-gray-700">Manage cohorts and their members.</p>
          </div>

          <div class="py-4">
            <CohortContainer.cohort_container cohorts={@cohorts} selected_cohort={@selected_cohort} />
          </div>
        </div>
      </div>
    </div>
    """
  end
end
