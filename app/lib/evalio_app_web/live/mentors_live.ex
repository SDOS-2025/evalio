defmodule EvalioAppWeb.MentorsLive do
  use EvalioAppWeb, :live_view
  import EvalioAppWeb.CoreComponents
  import PetalComponents

  alias EvalioAppWeb.Components.HomePage.Topbar

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket,
      mentors: [],
      search_text: "",
      sort_by: "name_asc"
    )}
  end

  @impl true
  def handle_event("sort_mentors", %{"sort" => sort_option}, socket) do
    {:noreply, assign(socket, sort_by: sort_option)}
  end

  @impl true
  def handle_info({:search_mentors, search_text}, socket) do
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
  def render(assigns) do
    ~H"""
    <div>
      <div class="fixed top-0 left-0 right-0 z-50">
        <Topbar.topbar />
      </div>

      <div class="pt-16">
        <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
          <div class="py-8">
            <h1 class="text-3xl font-bold text-gray-900">Mentors</h1>
            <p class="mt-2 text-sm text-gray-700">Manage mentors and their assignments.</p>
          </div>

          <div class="bg-white shadow overflow-hidden sm:rounded-md">
            <ul role="list" class="divide-y divide-gray-200">
              <%= for mentor <- filter_mentors_by_search(@mentors, @search_text) do %>
                <li>
                  <div class="px-4 py-4 sm:px-6">
                    <div class="flex items-center justify-between">
                      <div class="flex items-center">
                        <div class="flex-shrink-0">
                          <div class="h-12 w-12 rounded-full bg-gray-300 flex items-center justify-center">
                            <span class="text-xl font-medium text-gray-600">
                              <%= String.first(mentor.name) %>
                            </span>
                          </div>
                        </div>
                        <div class="ml-4">
                          <h2 class="text-lg font-medium text-gray-900"><%= mentor.name %></h2>
                          <p class="text-sm text-gray-500"><%= mentor.email %></p>
                        </div>
                      </div>
                      <div class="flex items-center space-x-4">
                        <span class="px-2 inline-flex text-xs leading-5 font-semibold rounded-full bg-blue-100 text-blue-800">
                          <%= mentor.mentee_count %> Mentees
                        </span>
                        <span class="px-2 inline-flex text-xs leading-5 font-semibold rounded-full bg-green-100 text-green-800">
                          Active
                        </span>
                      </div>
                    </div>
                  </div>
                </li>
              <% end %>
            </ul>
          </div>
        </div>
      </div>
    </div>
    """
  end

  defp filter_mentors_by_search(mentors, ""), do: mentors
  defp filter_mentors_by_search(mentors, search_text) do
    search_text = String.downcase(search_text)
    Enum.filter(mentors, fn mentor ->
      String.contains?(String.downcase(mentor.name), search_text) ||
      String.contains?(String.downcase(mentor.email), search_text)
    end)
  end
end
