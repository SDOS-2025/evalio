defmodule EvalioAppWeb.PageLive do
  use EvalioAppWeb, :live_view
  # import EvalioAppWeb.CoreComponents
  # import PetalComponents

  def mount(_params, _session, socket) do
    {:ok, assign(socket, show_form: false, title: "", content: "", notes: [])}
  end

  # def mount(_params, _session, socket) do
  #   {:ok, assign(socket, show_form: false, title: "", content: "")}
  # end

  def render(assigns) do
    ~H"""
    <div class="flex justify-start">
      <.button color="primary" label="New Note" phx-click="toggle_form" />
    </div>

    <%= if @show_form do %>
      <div class="mt-4 max-w-md">
        <.form phx-submit="save_note">
          <PetalComponents.Input.input name="title" label="Title" placeholder="Note Title" value={@title} />
          <PetalComponents.Input.input name="content" label="Content" placeholder="Write your note here..." value={@content} />

          <div class="mt-4">
            <.button label="Save" color="green" />
            <.button label="Cancel" color="red" phx-click="toggle_form" type="button" />
          </div>
        </.form>
      </div>
    <% end %>

    <div class="mt-8 grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-4">
      <%= for note <- @notes do %>
        <.card variant="outline">
          <.card_content heading={note.title}>
            <p><%= note.content %></p>
          </.card_content>
        </.card>
      <% end %>
    </div>
    """
  end

  def handle_event("toggle_form", _params, socket) do
    IO.inspect("Toggle form clicked")
    {:noreply, assign(socket, show_form: !socket.assigns.show_form)}
  end



  def handle_event("save_note", %{"title" => title, "content" => content}, socket) do
    new_note = %{title: title, content: content}
    notes = [new_note | socket.assigns.notes]


    IO.puts("All Notes:")
    Enum.each(notes, fn note ->
      IO.puts("Title: #{note.title}, Content: #{note.content}")
    end)

    {:noreply,
     socket
     |> assign(:notes, notes)
     |> assign(:show_form, false)
     |> assign(:title, "")
     |> assign(:content, "")}
  end


end
