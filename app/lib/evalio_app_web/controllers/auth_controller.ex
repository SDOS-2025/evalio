defmodule EvalioAppWeb.AuthController do
  use EvalioAppWeb, :controller

  def python_callback(conn, %{"token" => token}) do
    # In production, verify the token (e.g., call Python service or decode JWT)
    # For demo, just use the token as user_id
    user = %{id: token}

    conn
    |> put_session(:user, user)
    |> put_flash(:info, "Logged in with Google!")
    |> redirect(to: "/notes")
  end
end
