defmodule EvalioAppWeb.MentorsLive do
  use EvalioAppWeb, :live_view
  import EvalioAppWeb.Components.Mentors.MentorCard

  alias EvalioAppWeb.Components.HomePage.Topbar

  def mount(_params, _session, socket) do
    # Hardcoded mentor data for UI preview
    mentors = get_mentors()

    {:ok, assign(socket, mentors: mentors, search_text: "")}
  end

  @impl true
  def handle_event("search", %{"search" => search_text}, socket) do
    mentors =
      get_mentors()
      |> Enum.filter(fn mentor ->
        String.contains?(
          String.downcase("#{mentor.first_name} #{mentor.last_name} #{mentor.email}"),
          String.downcase(search_text)
        )
      end)

    {:noreply, assign(socket, search_text: search_text, mentors: mentors)}
  end

  @impl true
  def handle_event("navigate", %{"to" => path}, socket) do
    {:noreply, push_navigate(socket, to: path)}
  end

  @impl true
  def handle_event("logout", _params, socket) do
    {:noreply, push_navigate(socket, to: "/login")}
  end

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
              <h1 class="text-3xl font-bold text-gray-900">Mentors</h1>
            </div>
          </div>
        </div>
        <!-- Search input -->
        <div class="w-64 mb-6">
          <.form for={%{}} phx-change="search" class="relative">
            <input
              type="text"
              name="search"
              value={@search_text}
              placeholder="Search mentors..."
              class="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-indigo-500 focus:border-indigo-500"
              phx-debounce="300"
            />
          </.form>
        </div>
        <div class="w-full">
          <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
            <%= for mentor <- @mentors do %>
              <.mentor_card mentor={mentor} />
            <% end %>
          </div>
        </div>
      </div>
    </div>
    """
  end

  defp get_mentors do
    [
      %{
        id: 1,
        first_name: "John",
        last_name: "Doe",
        email: "john.doe@example.com",
        pronouns: "he/him",
        profile_picture: "https://robohash.org/1.png?size=50x50&set=set1",
        year_since: "2020"
      },
      %{
        id: 2,
        first_name: "Jane",
        last_name: "Smith",
        email: "jane.smith@example.com",
        pronouns: "she/her",
        profile_picture: "https://robohash.org/2.png?size=50x50&set=set1",
        year_since: "2019"
      },
      %{
        id: 3,
        first_name: "Alex",
        last_name: "Johnson",
        email: "alex.johnson@example.com",
        pronouns: "they/them",
        profile_picture: "https://robohash.org/3.png?size=50x50&set=set1",
        year_since: "2021"
      },
      %{
        id: 4,
        first_name: "Sarah",
        last_name: "Williams",
        email: "sarah.williams@example.com",
        pronouns: "she/her",
        profile_picture: "https://robohash.org/4.png?size=50x50&set=set1",
        year_since: "2018"
      },
      %{
        id: 5,
        first_name: "Michael",
        last_name: "Brown",
        email: "michael.brown@example.com",
        pronouns: "he/him",
        profile_picture: "https://robohash.org/5.png?size=50x50&set=set1",
        year_since: "2022"
      },
      %{
        id: 6,
        first_name: "Emily",
        last_name: "Davis",
        email: "emily.davis@example.com",
        pronouns: "she/her",
        profile_picture: "https://robohash.org/6.png?size=50x50&set=set1",
        year_since: "2020"
      },
      %{
        id: 7,
        first_name: "David",
        last_name: "Miller",
        email: "david.miller@example.com",
        pronouns: "he/him",
        profile_picture: "https://robohash.org/7.png?size=50x50&set=set1",
        year_since: "2019"
      },
      %{
        id: 8,
        first_name: "Lisa",
        last_name: "Wilson",
        email: "lisa.wilson@example.com",
        pronouns: "she/her",
        profile_picture: "https://robohash.org/8.png?size=50x50&set=set1",
        year_since: "2021"
      },
      %{
        id: 9,
        first_name: "James",
        last_name: "Taylor",
        email: "james.taylor@example.com",
        pronouns: "he/him",
        profile_picture: "https://robohash.org/9.png?size=50x50&set=set1",
        year_since: "2018"
      },
      %{
        id: 10,
        first_name: "Emma",
        last_name: "Anderson",
        email: "emma.anderson@example.com",
        pronouns: "she/her",
        profile_picture: "https://robohash.org/10.png?size=50x50&set=set1",
        year_since: "2022"
      }
    ]
  end
end
