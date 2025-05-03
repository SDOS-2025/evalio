defmodule EvalioAppWeb.SessionsLive do
  use EvalioAppWeb, :live_view
  import EvalioAppWeb.CoreComponents
  import PetalComponents

  import EvalioAppWeb.Components.Sessions.SessionCard

  alias EvalioAppWeb.Components.HomePage.Topbar
  alias EvalioAppWeb.Components.Sessions.SessionContainer
  alias EvalioApp.Session

  @impl true
  def mount(_params, _session, socket) do
    sessions = [
      %Session{
        id: "1",
        topic: "System Design",
        cohort: "WE-345",
        date: ~D[2024-03-15],
        duration: 60,
        transcript:
          "Discussion about project progress and challenges faced by mentees. Key points covered: 1) Time management strategies 2) Technical roadblocks 3) Next steps for project completion",
        num_attendees: 12,
        attendance_percentage: 85.7
      },
      %Session{
        id: "2",
        topic: "Corporate Skills",
        cohort: "WE-201",
        date: ~D[2024-03-10],
        duration: 90,
        transcript:
          "Workshop on advanced programming concepts. Topics covered: 1) Design patterns 2) Code optimization 3) Best practices for team collaboration",
        num_attendees: 15,
        attendance_percentage: 93.8
      },
      %Session{
        id: "3",
        topic: "GenAI",
        cohort: "WE-501",
        date: ~D[2024-03-05],
        duration: 45,
        transcript:
          "One-on-one mentoring sessions with focus on individual project goals and progress tracking",
        num_attendees: 8,
        attendance_percentage: 66.7
      },
      %Session{
        id: "4",
        topic: "System Design",
        cohort: "WISE-501",
        date: ~D[2024-02-28],
        duration: 75,
        transcript:
          "Group discussion on career development and industry trends. Guest speaker from tech industry shared insights on current job market",
        num_attendees: 18,
        attendance_percentage: 95.0
      }
    ]

    {:ok, assign(socket, sessions: sessions, selected_session: nil)}
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
    <div class="min-h-screen">
      <div class="fixed top-0 left-0 right-0 z-50">
        <Topbar.topbar />
      </div>

      <div class="fixed left-0 top-0 pt-16 px-4 sm:px-6 lg:px-8 w-full">
        <div class="py-8">
          <div class="flex justify-between items-center">
            <div>
              <p></p>
              <h1 class="text-3xl font-bold text-gray-900">Sessions</h1>
            </div>
          </div>
        </div>

        <div class="w-full">
          <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
            <%= for session <- @sessions do %>
              <.session_card session={session} />
            <% end %>
          </div>
        </div>
      </div>
    </div>
    """
  end
end
