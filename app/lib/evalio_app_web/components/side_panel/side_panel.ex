defmodule EvalioAppWeb.SidePanel do
  use EvalioAppWeb, :live_component
  import PetalComponents

  def render(assigns) do
    ~H"""
    <div class="fixed right-0 top-0 h-screen w-1/3 bg-gray-200 dark:bg-gray-900 shadow-lg">
      <.container class="h-full px-4 py-4 flex flex-col">
        <!-- Button Container -->
          <div class="w-full max-w-[90%] mx-auto flex justify-between mb-4">
            <.button class="w-80 bg-transparent text-black dark:text-white border-none outline-none shadow-none">
              Profile
            </.button>
            <.button class="bg-green-500 dark:bg-green-700 text-white px-4 py-2 rounded-lg">
              Stats
            </.button>
          </div>

        <!-- Scrollable Content -->
        <div class="overflow-y-auto flex-grow space-y-4">
          <!-- Calendar Card -->
          <.card class="w-full max-w-[90%] mx-auto aspect-square bg-white dark:bg-gray-800 shadow-md rounded-2xl flex items-center justify-center">
            <h3 class="text-lg font-semibold text-gray-900 dark:text-gray-100">Calendar</h3>
          </.card>

          <!-- Reminders Card -->
          <.card class="w-full max-w-[90%] mx-auto aspect-square bg-white dark:bg-gray-800 shadow-md rounded-2xl relative p-4 flex flex-col">
            <h4 class="absolute top-3 left-4 text-lg font-bold text-gray-800 dark:text-gray-200">Reminders</h4>
            <div class="mt-8 h-[calc(100%-40px)] w-full overflow-y-auto bg-gray-100 dark:bg-gray-700 rounded-lg p-2 space-y-2">
              <.card class="w-[95%] mx-auto h-20 bg-gray-300 dark:bg-gray-600 shadow-md rounded-lg p-3"></.card>
              <.card class="w-[95%] mx-auto h-20 bg-gray-300 dark:bg-gray-600 shadow-md rounded-lg p-3"></.card>
              <.card class="w-[95%] mx-auto h-20 bg-gray-300 dark:bg-gray-600 shadow-md rounded-lg p-3"></.card>
              <.card class="w-[95%] mx-auto h-20 bg-gray-300 dark:bg-gray-600 shadow-md rounded-lg p-3"></.card>
              <.card class="w-[95%] mx-auto h-20 bg-gray-300 dark:bg-gray-600 shadow-md rounded-lg p-3"></.card>
              <.card class="w-[95%] mx-auto h-20 bg-gray-300 dark:bg-gray-600 shadow-md rounded-lg p-3"></.card>
              <.card class="w-[95%] mx-auto h-20 bg-gray-300 dark:bg-gray-600 shadow-md rounded-lg p-3"></.card>
            </div>
          </.card>

          <!-- Meetings Card -->
          <.card class="w-full max-w-[90%] mx-auto aspect-square bg-white dark:bg-gray-800 shadow-md rounded-2xl relative p-4 flex flex-col">
            <h4 class="absolute top-3 left-4 text-lg font-bold text-gray-800 dark:text-gray-200">Meetings</h4>
            <div class="mt-8 h-[calc(100%-40px)] w-full overflow-y-auto bg-gray-100 dark:bg-gray-700 rounded-lg p-2 space-y-2">
              <.card class="w-[95%] mx-auto h-20 bg-gray-300 dark:bg-gray-600 shadow-md rounded-lg p-3"></.card>
              <.card class="w-[95%] mx-auto h-20 bg-gray-300 dark:bg-gray-600 shadow-md rounded-lg p-3"></.card>
              <.card class="w-[95%] mx-auto h-20 bg-gray-300 dark:bg-gray-600 shadow-md rounded-lg p-3"></.card>
              <.card class="w-[95%] mx-auto h-20 bg-gray-300 dark:bg-gray-600 shadow-md rounded-lg p-3"></.card>
              <.card class="w-[95%] mx-auto h-20 bg-gray-300 dark:bg-gray-600 shadow-md rounded-lg p-3"></.card>
              <.card class="w-[95%] mx-auto h-20 bg-gray-300 dark:bg-gray-600 shadow-md rounded-lg p-3"></.card>
              <.card class="w-[95%] mx-auto h-20 bg-gray-300 dark:bg-gray-600 shadow-md rounded-lg p-3"></.card>
            </div>
          </.card>
        </div>
      </.container>
    </div>
    """
  end
end
