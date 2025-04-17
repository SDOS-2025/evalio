defmodule EvalioAppWeb.Components.Note.ReadingNote do
  use EvalioAppWeb, :live_component

  def render(assigns) do
    ~H"""
    <div class="fixed inset-0 z-[200]">
      <div class="fixed inset-0 bg-black/30 backdrop-blur-lg"></div>
      <div class="fixed inset-0 flex items-center justify-center">
        <div class="relative z-[201]">
          <div class="bg-white rounded-lg shadow-lg w-[800px] h-[600px]">
            <div class="h-full flex flex-col">
              <div class="p-6 border-b border-gray-200">
                <div class="flex justify-between items-center">
                  <h3 class="font-bold text-2xl"><%= @note.title %></h3>
                  <button phx-click="close_read_mode" class="text-gray-500 hover:text-gray-700">
                    <svg xmlns="http://www.w3.org/2000/svg" class="h-6 w-6" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                      <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12" />
                    </svg>
                  </button>
                </div>
              </div>
              <div class="flex-1 overflow-y-auto p-6">
                <div class="text-gray-700 text-lg">
                  <%= for line <- String.split(@note.content, "\n") do %>
                    <div class="whitespace-pre-wrap"><%= line %></div>
                  <% end %>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
    """
  end
end 