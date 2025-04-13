defmodule EvalioAppWeb.Router do
  use EvalioAppWeb, :router

  import Phoenix.LiveView.Router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {EvalioAppWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", EvalioAppWeb do
    pipe_through :browser

    # Auth routes
    live "/", AuthLive
    live "/login", AuthLive
    live "/signup", AuthLive

    # Notes routes
    live "/notes", NotesLive
    live "/notes/new", NotesLive
    live "/notes/:id/edit", NotesLive
  end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:evalio_app, :dev_routes) do
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: EvalioAppWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
