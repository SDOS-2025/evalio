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
      <%= for {note, index} <- Enum.with_index(@notes) do %>
        <.card class="mt-4 flex flex-col justify-between p-4">
          <.card_content heading={note.title} class="flex-grow">
            <p><%= note.content %></p>
          </.card_content>

          <div class="mt-4 flex justify-end">
            <.button label="Delete" color="red" phx-click="delete_note" phx-value-index={index} />
          </div>
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

  def handle_event("delete_note", %{"index" => index}, socket) do
    notes = Enum.with_index(socket.assigns.notes) # Add index to notes list
             |> Enum.reject(fn {_note, i} -> Integer.to_string(i) == index end) # Remove the note at the given index
             |> Enum.map(fn {note, _i} -> note end) # Extract the note back

    IO.puts("Note Deleted! All Notes:")
    Enum.each(notes, fn note ->
      IO.puts("Title: #{note.title}, Content: #{note.content}")
    end)

    {:noreply, assign(socket, :notes, notes)}
  end






end
