defmodule EvalioAppWeb.Plugs.RequireAuthenticatedUser do
  import Plug.Conn
  import Phoenix.Controller

  def init(opts), do: opts

  def call(conn, _opts) do
    if user_token = get_session(conn, :user_token) do
      # In a real app, you would fetch the user from the database
      # For now, we'll just check if the token matches our allowed user
      if user_token == "admin@evalio.com" do
        conn
      else
        conn
        |> put_flash(:error, "You must log in to access this page.")
        |> redirect(to: "/login")
        |> halt()
      end
    else
      conn
      |> put_flash(:error, "You must log in to access this page.")
      |> redirect(to: "/login")
      |> halt()
    end
  end
end
