defmodule EvalioApp.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      EvalioAppWeb.Telemetry,
      EvalioApp.Repo,
      {DNSCluster, query: Application.get_env(:evalio_app, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: EvalioApp.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: EvalioApp.Finch},
      # Start a worker by calling: EvalioApp.Worker.start_link(arg)
      # {EvalioApp.Worker, arg},
      # Start to serve requests, typically the last entry
      EvalioAppWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: EvalioApp.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    EvalioAppWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
