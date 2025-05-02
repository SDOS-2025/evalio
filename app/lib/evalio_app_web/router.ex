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

  # Public routes
  scope "/", EvalioAppWeb do
    pipe_through :browser

    live "/", AuthLive, :home
    live "/login", AuthLive, :login
    live "/signup", AuthLive, :signup

    get "/auth/google/callback", AuthController, :python_callback
  end

  # Protected routes
  scope "/", EvalioAppWeb do
    pipe_through :browser

    live "/notes", NotesLive, :index
    live "/notes/new", NotesLive, :new
    live "/notes/:id/edit", NotesLive, :edit
    live "/mentees", MenteesLive, :index
    live "/mentors", MentorsLive, :index
    live "/cohorts", CohortsLive, :index
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
