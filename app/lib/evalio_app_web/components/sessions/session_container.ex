defmodule EvalioAppWeb.Components.Sessions.SessionContainer do
  use Phoenix.Component
  import Phoenix.LiveView
  alias EvalioAppWeb.Components.Sessions.SessionCard

  attr :sessions, :list, required: true
  attr :on_session_click, :string, default: nil

  def session_container(assigns) do
    ~H"""
    <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-4">
      <%= for session <- @sessions do %>
        <SessionCard.session_card session={session} on_click={@on_session_click} />
      <% end %>
    </div>
    """
  end
end
