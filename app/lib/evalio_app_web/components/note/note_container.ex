defmodule EvalioAppWeb.NoteContainer do
  use EvalioAppWeb, :live_component
  import PetalComponents

  alias EvalioAppWeb.NoteCard

  def render(assigns) do
    ~H"""
    <div class="absolute top-[170px] left-0 w-2/3">
      <.container max_width="full" class="max-h-[calc(100vh-170px)] overflow-y-auto p-4 rounded-lg">
        <div class="grid grid-cols-1 sm:grid-cols-2 md:grid-cols-3 gap-4">
          <%= if @notes && length(@notes) > 0 do %>
            <%= for note <- @notes do %>
              <.live_component module={NoteCard} id={"note-#{note.id}"} note={note} editing={note.editing} />
            <% end %>
          <% else %>
            <div class="col-span-full text-center text-gray-500 py-8">
              No notes yet. Click "New Note" to create one.
            </div>
          <% end %>
        </div>
      </.container>
    </div>
    """
  end

  def update(assigns, socket) do
    {:ok, assign(socket, assigns)}
  end
end
