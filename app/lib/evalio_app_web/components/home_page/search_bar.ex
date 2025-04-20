defmodule EvalioAppWeb.HomePage.SearchBar do
  use EvalioAppWeb, :live_component

  def mount(socket) do
    {:ok, assign(socket, expanded: false, search_text: "")}
  end

  def handle_event("toggle_search", _, socket) do
    {:noreply, assign(socket, expanded: !socket.assigns.expanded)}
  end

  def handle_event("search", %{"search" => %{"text" => text}}, socket) do
    send(self(), {:search_notes, text})
    {:noreply, assign(socket, search_text: text)}
  end

  def render(assigns) do
    ~H"""
    <div class="relative flex justify-center">
      <div class={
        "flex items-center rounded-xl shadow-md transition-all duration-300 ease-in-out #{if @expanded, do: "w-[400px] bg-white", else: "w-[50px] bg-black"}"
      }>
        <button
          type="button"
          class="w-[50px] h-[50px] rounded-full flex items-center justify-center group"
          phx-click={JS.push("toggle_search", target: @myself)}
        >
          <svg
            class={"w-[30px] h-[30px] transition-colors #{if @expanded, do: "text-[#171717] group-hover:text-[#666666]", else: "text-white group-hover:text-gray-300"}"}
            viewBox="0 0 24 24"
            xmlns="http://www.w3.org/2000/svg"
          >
            <path
              fill="currentColor"
              d="M15.5 14h-.79l-.28-.27C15.41 12.59 16 11.11 16 9.5 16 5.91 13.09 3 9.5 3S3 5.91 3 9.5 5.91 16 9.5 16c1.61 0 3.09-.59 4.23-1.57l.27.28v.79l5 4.99L20.49 19l-4.99-5zm-6 0C7.01 14 5 11.99 5 9.5S7.01 5 9.5 5 14 7.01 14 9.5 11.99 14 9.5 14z"
            />
          </svg>
        </button>

        <form :if={@expanded} class="flex-1 pr-4" phx-change="search" phx-target={@myself}>
          <input
            type="text"
            name="search[text]"
            value={@search_text}
            class="w-full bg-transparent border-none focus:outline-none text-[#171717] placeholder-[#666666]"
            placeholder="Search notes..."
            autocomplete="off"
          />
        </form>
      </div>
    </div>
    """
  end
end
