defmodule EvalioAppWeb.HomePage.NewNote do
  use EvalioAppWeb, :live_component
  import PetalComponents

  def render(assigns) do
    ~H"""
    <div class="bg-white rounded-lg shadow-md p-4 w-[660px] h-[60px] flex flex-row items-center">
      <button class="text-gray-400 text-lg hover:text-gray-500 transition-colors" phx-click="toggle_form">
        Take a note...
      </button>
      <div class="flex-grow"></div>
      <div class="flex justify-end items-center space-x-4">
        <button class="p-2 rounded-lg hover:bg-gray-100 transition-all">
          <PetalComponents.Icon.icon name="hero-list-bullet" class="w-5 h-5 text-gray-600" />
        </button>
        <button class="p-2 rounded-lg hover:bg-gray-100 transition-all">
          <PetalComponents.Icon.icon name="hero-calendar" class="w-5 h-5 text-gray-600" />
        </button>
        <button class="p-2 rounded-lg hover:bg-gray-100 transition-all">
          <PetalComponents.Icon.icon name="hero-photo" class="w-5 h-5 text-gray-600" />
        </button>
      </div>
    </div>
    """
  end
end
