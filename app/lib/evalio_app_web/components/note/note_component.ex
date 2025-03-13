defmodule EvalioAppWeb.NoteComponent do
  use EvalioAppWeb, :live_component
  import PetalComponents

  def render(assigns) do
    ~H"""
    <div>
      <.card class="mt-4 flex flex-col justify-between p-4">
        <.card_content heading={@note.title} class="flex-grow">
          <p><%= @note.content %></p>
        </.card_content>
        <div class="mt-4 flex justify-end">
          <.button label="Delete" color="red" phx-click="delete_note" phx-value-index={@index} />
        </div>
      </.card>
    </div>
    """
  end
end
