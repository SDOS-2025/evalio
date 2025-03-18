defmodule EvalioAppWeb.NoteContainer do
  use EvalioAppWeb, :live_component
  import PetalComponents

  alias EvalioAppWeb.NoteCard  # Importing the NoteCard component

  def render(assigns) do
    # Generate 25 hardcoded notes
    notes = for i <- 1..25 do
      %{id: i, title: "Note #{i}", content: "This is a sample note content for note #{i}."}
    end

    ~H"""
    <div class="absolute top-[170px] left-0 w-2/3">
      <.container max_width="full" class="max-h-[calc(100vh-170px)] overflow-y-auto p-4 border border-gray-300 rounded-lg">
        <div class="grid grid-cols-1 sm:grid-cols-2 md:grid-cols-3 gap-4">
          <%= for note <- notes do %>
            <.live_component module={NoteCard} id={"note-#{note.id}"} note={note} index={note.id} />
          <% end %>
        </div>
      </.container>
    </div>
    """
  end
end
