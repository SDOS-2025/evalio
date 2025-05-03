defmodule EvalioAppWeb.AuthController do
  use EvalioAppWeb, :controller
  alias EvalioApp.TokenVerifier

  def python_callback(conn, %{"token" => token}) do
    case TokenVerifier.verify_token(token) do
      {:ok, claims} ->
        # Extract user information from claims
        user = %{
          id: claims["sub"],
          email: claims["email"],
          name: claims["name"]
        }

        conn
        |> put_session(:user, user)
        |> put_flash(:info, "Logged in with Google!")
        |> redirect(to: "/notes")

      {:error, reason} ->
        conn
        |> put_flash(:error, "Invalid token: #{inspect(reason)}")
        |> redirect(to: "/login")
    end
  end

  def logout(conn, _params) do
    conn
    |> configure_session(drop: true)
    |> put_flash(:info, "Logged out successfully.")
    |> redirect(to: "/login")
  end
end
