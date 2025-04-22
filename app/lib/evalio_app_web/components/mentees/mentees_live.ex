defmodule EvalioAppWeb.MenteesLive do
  use EvalioAppWeb, :live_view
  import EvalioAppWeb.CoreComponents

  alias EvalioAppWeb.Components.HomePage.Topbar
  alias EvalioAppWeb.Components.Mentees.MenteeContainer
  alias EvalioApp.Mentee

  @impl true
  def mount(_params, _session, socket) do
    mentees = Mentee.list_mentees()
    # Set first 4 mentees as expanded if there are any mentees
    mentees =
      case mentees do
        [] ->
          []

        list when length(list) >= 4 ->
          [first, second, third, fourth | rest] = list

          [
            %{first | is_expanded: false},
            %{second | is_expanded: false},
            %{third | is_expanded: false},
            %{fourth | is_expanded: false}
            | rest
          ]

        list ->
          Enum.map(list, &%{&1 | is_expanded: true})
      end

    {:ok,
     assign(socket,
       mentees: mentees,
       search_text: "",
       sort_by: "name_asc"
     )}
  end

  @impl true
  def handle_event("search", %{"search" => search_text}, socket) do
    send(self(), {:search_mentees, search_text})
    {:noreply, socket}
  end

  @impl true
  def handle_event("sort_mentees", %{"sort" => sort_option}, socket) do
    {:noreply, assign(socket, sort_by: sort_option)}
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
  def handle_event("toggle_expand", %{"mentee_id" => mentee_id}, socket) do
    mentees =
      Enum.map(socket.assigns.mentees, fn mentee ->
        if to_string(mentee.id) == mentee_id do
          %{mentee | is_expanded: !mentee.is_expanded}
        else
          mentee
        end
      end)

    {:noreply, assign(socket, mentees: mentees)}
  end

  @impl true
  def handle_info({:search_mentees, search_text}, socket) do
    mentees =
      if search_text == "" do
        Mentee.list_mentees()
      else
        Mentee.search_mentees(search_text)
      end

    {:noreply, assign(socket, search_text: search_text, mentees: mentees)}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div class="min-h-screen">
      <div class="fixed top-0 left-0 right-0 z-50">
        <Topbar.topbar />
      </div>

      <div class="fixed left-0 top-0 pt-16 px-4 sm:px-6 lg:px-8 w-full">
        <div class="py-8">
          <div class="flex justify-between items-center">
            <div>
              <p></p>
              <h1 class="text-3xl font-bold text-gray-900">Mentees</h1>
            </div>
            <div class="w-64">
              <.form for={%{}} phx-change="search" class="relative">
                <input
                  type="text"
                  name="search"
                  value={@search_text}
                  placeholder="Search mentees..."
                  class="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-indigo-500 focus:border-indigo-500"
                  phx-debounce="300"
                />
              </.form>
            </div>
          </div>
        </div>

        <div class="w-full">
          <MenteeContainer.mentee_container mentees={@mentees} />
        </div>
      </div>
    </div>
    """
  end
end
