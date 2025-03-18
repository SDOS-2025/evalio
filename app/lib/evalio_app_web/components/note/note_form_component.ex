defmodule EvalioAppWeb.NoteFormComponent do
  use EvalioAppWeb, :live_component
  import PetalComponents
  import PetalComponents.Input

  def render(assigns) do
    ~H"""
    <div class="absolute top-[10px] right-0">
      <.form phx-submit="save_note">
        <PetalComponents.Input.input name="title" label="Title" placeholder="Note Title" value={@title} />
        <PetalComponents.Input.input name="content" label="Content" placeholder="Write your note here..." value={@content} />

        <div class="mt-4">
          <.button label="Save" color="green" />
          <.button label="Cancel" color="red" phx-click="toggle_form" type="button" />
        </div>
      </.form>
    </div>
    """
  end
end
