defmodule EvalioAppWeb.PageLive do
  use EvalioAppWeb, :live_view
  # import EvalioAppWeb.CoreComponents
  # import PetalComponents

  def mount(_params, _session, socket) do
    {:ok, assign(socket, show_form: false, title: "", content: "")}
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
    """
  end


  def mount(_params, _session, socket) do
    {:ok, assign(socket, show_form: false, title: "", content: "")}
  end


  def handle_event("toggle_form", _params, socket) do
    IO.inspect("Toggle form clicked")
    {:noreply, assign(socket, show_form: !socket.assigns.show_form)}
  end

  def handle_event("save_note", %{"title" => title, "content" => content}, socket) do
    IO.puts("New Note: #{title} - #{content}")
    {:noreply, assign(socket, show_form: false, title: "", content: "")}
  end
  
end
