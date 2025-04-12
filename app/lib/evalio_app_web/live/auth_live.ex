defmodule EvalioAppWeb.AuthLive do
  use EvalioAppWeb, :live_view

  def mount(_params, _session, socket) do
    {:ok, assign(socket, form: to_form(%{}, as: "user"), page: "login", error_message: nil)}
  end

  def handle_event("switch-page", %{"page" => page}, socket) do
    {:noreply, assign(socket, page: page, error_message: nil)}
  end

  def handle_event("login", %{"user" => user_params}, socket) do
    email = user_params["email"]
    password = user_params["password"]

    if email == "admin@evalio.com" && password == "password123" do
      {:noreply,
       socket
       |> put_flash(:info, "Welcome back!")
       |> push_navigate(to: ~p"/notes")}
    else
      {:noreply,
       socket
       |> assign(:error_message, "Invalid email or password")
       |> assign(:form, to_form(%{}, as: "user"))}
    end
  end

  def handle_event("signup", %{"user" => user_params}, socket) do
    # For now, we'll just show an error message since we're only allowing a specific login
    {:noreply,
     socket
     |> assign(:error_message, "Sign up is currently disabled. Please use the provided credentials.")
     |> assign(:form, to_form(%{}, as: "user"))}
  end

  def render(assigns) do
    ~H"""
    <div class="min-h-screen bg-gray-100 flex flex-col justify-center py-12 sm:px-6 lg:px-8">
      <div class="sm:mx-auto sm:w-full sm:max-w-md">
        <h2 class="mt-6 text-center text-3xl font-extrabold text-gray-900">
          <%= if @page == "login", do: "Sign in to your account", else: "Create your account" %>
        </h2>
      </div>

      <div class="mt-8 sm:mx-auto sm:w-full sm:max-w-md">
        <div class="bg-white py-8 px-4 shadow sm:rounded-lg sm:px-10">
          <%= if @error_message do %>
            <div class="mb-4 p-4 text-sm text-red-700 bg-red-100 rounded-lg">
              <%= @error_message %>
            </div>
          <% end %>

          <.form for={@form} phx-submit={if @page == "login", do: "login", else: "signup"} class="space-y-6">
            <div>
              <label for="email" class="block text-sm font-medium text-gray-700">Email address</label>
              <div class="mt-1">
                <input id="email" name="user[email]" type="email" required class="appearance-none block w-full px-3 py-2 border border-gray-300 rounded-md shadow-sm placeholder-gray-400 focus:outline-none focus:ring-indigo-500 focus:border-indigo-500 sm:text-sm">
              </div>
            </div>

            <div>
              <label for="password" class="block text-sm font-medium text-gray-700">Password</label>
              <div class="mt-1">
                <input id="password" name="user[password]" type="password" required class="appearance-none block w-full px-3 py-2 border border-gray-300 rounded-md shadow-sm placeholder-gray-400 focus:outline-none focus:ring-indigo-500 focus:border-indigo-500 sm:text-sm">
              </div>
            </div>

            <%= if @page == "signup" do %>
              <div>
                <label for="password_confirmation" class="block text-sm font-medium text-gray-700">Confirm Password</label>
                <div class="mt-1">
                  <input id="password_confirmation" name="user[password_confirmation]" type="password" required class="appearance-none block w-full px-3 py-2 border border-gray-300 rounded-md shadow-sm placeholder-gray-400 focus:outline-none focus:ring-indigo-500 focus:border-indigo-500 sm:text-sm">
                </div>
              </div>
            <% end %>

            <div>
              <button type="submit" class="w-full flex justify-center py-2 px-4 border border-transparent rounded-md shadow-sm text-sm font-medium text-white bg-indigo-600 hover:bg-indigo-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-indigo-500">
                <%= if @page == "login", do: "Sign in", else: "Sign up" %>
              </button>
            </div>
          </.form>

          <div class="mt-6">
            <div class="relative">
              <div class="absolute inset-0 flex items-center">
                <div class="w-full border-t border-gray-300"></div>
              </div>
              <div class="relative flex justify-center text-sm">
                <span class="px-2 bg-white text-gray-500">
                  <%= if @page == "login", do: "New to Evalio?", else: "Already have an account?" %>
                </span>
              </div>
            </div>

            <div class="mt-6">
              <button phx-click="switch-page" phx-value-page={if @page == "login", do: "signup", else: "login"} class="w-full flex justify-center py-2 px-4 border border-transparent rounded-md shadow-sm text-sm font-medium text-indigo-600 bg-white hover:bg-gray-50 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-indigo-500">
                <%= if @page == "login", do: "Create an account", else: "Sign in" %>
              </button>
            </div>
          </div>
        </div>
      </div>
    </div>
    """
  end
end
