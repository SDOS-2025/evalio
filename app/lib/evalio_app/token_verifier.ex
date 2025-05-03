defmodule EvalioApp.TokenVerifier do
  use Joken.Config

  @impl true
  def token_config do
    default_claims(aud: "evalio_app")
    |> add_claim("iss", fn -> "google_auth_server" end, &(&1 == "google_auth_server"))
  end

  def verify_token(token) do
    signer = Joken.Signer.create("HS256", Application.get_env(:joken, :default_signer))
    case __MODULE__.verify_and_validate(token, signer) do
      {:ok, claims} -> {:ok, claims}
      {:error, reason} -> {:error, reason}
    end
  end
end
