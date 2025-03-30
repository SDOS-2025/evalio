defmodule EvalioAppWeb.NoteContainer do
  use EvalioAppWeb, :live_component
  import PetalComponents

  alias EvalioAppWeb.NoteCard

  def render(assigns) do
    ~H"""
    <div class="fixed top-[200px] left-0 w-2/3 h-[calc(100vh-170px)] overflow-y-auto">
      <div class="grid grid-cols-3 gap-6 p-6">
        <%= for note <- @notes do %>
          <.live_component module={NoteCard} id={"note-#{note.id}"} note={note} editing={false} />
        <% end %>
      </div>
    </div>
    """
  end

  def update(assigns, socket) do
    {:ok, assign(socket, assigns)}
  end
end
