defmodule EvalioAppWeb.MentorsLive do
  use EvalioAppWeb, :live_view
  import EvalioAppWeb.CoreComponents
  import PetalComponents

  alias EvalioAppWeb.Components.HomePage.Topbar

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     assign(socket,
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
      <p>Mentors</p>
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
