defmodule EvalioAppWeb.PageLive do
  use EvalioAppWeb, :live_view
  # import EvalioAppWeb.CoreComponents
  # import PetalComponents

  def mount(_params, _session, socket) do
    {:ok, assign(socket, :count, 0)}
  end

  def render(assigns) do
    ~H"""
    <.button color="success" label="Success" />
    """
  end

  # def handle_event("clicked", _params, socket) do
  #   IO.puts("Button clicked!")
  #   {:noreply, socket}
  # end

end
