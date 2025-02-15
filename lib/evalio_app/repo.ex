defmodule EvalioApp.Repo do
  use Ecto.Repo,
    otp_app: :evalio_app,
    adapter: Ecto.Adapters.Postgres
end
