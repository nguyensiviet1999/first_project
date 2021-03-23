defmodule FirstProjectWeb.Router do
  use FirstProjectWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug FirstProjectWeb.Plugs.Locale, "en"
    plug FirstProjectWeb.Auth, repo: FirstProject.Repo
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", FirstProjectWeb do
    pipe_through :browser

    get "/", PageController, :index
    get "/hello/:name", HelloController, :world
    resources "/users", UserController
    resources "/categories", CategoryController
    resources "/sessions", SessionController, only: [:new, :create, :delete]
    get "/watch/:id", WatchController, :show
  end
  scope "/manage", FirstProjectWeb do
    pipe_through [:browser, :authenticate_user]
    resources "/videos", VideoController
  end
  # Other scopes may use custom stacks.
  # scope "/api", FirstProjectWeb do
  #   pipe_through :api
  # end

  # Enables LiveDashboard only for development
  #
  # If you want to use the LiveDashboard in production, you should put
  # it behind authentication and allow only admins to access it.
  # If your application does not have an admins-only section yet,
  # you can use Plug.BasicAuth to set up some basic authentication
  # as long as you are also using SSL (which you should anyway).
  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through :browser
      live_dashboard "/dashboard", metrics: FirstProjectWeb.Telemetry
    end
  end
end
