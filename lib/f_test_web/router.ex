defmodule FTestWeb.Router do

  use FTestWeb, :router
  import FTest.UserAuth


  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {FTestWeb.LayoutView, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", FTestWeb do
    pipe_through [:browser]

    # get "/", PageController, :index
    live "/", UsersLive.Index, :index
    live "/new", UsersLive.Index, :new
    live "/:id/edit", UsersLive.Index, :edit
    # live "/login", UsersLive.LoginUser
    get "/login", AuthController, :index
    get "/logout", AuthController, :logout
    post "/login", AuthController, :login

    live "/profile", ProfileComponent
  end

  scope "/user", FTestWeb do
    pipe_through [:browser, :redirect_if_user_is_authenticated]

    get "/login", AuthController, :index
    post "/login", AuthController, :login
  end

  # Other scopes may use custom stacks.
  # scope "/api", FTestWeb do
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

      live_dashboard "/dashboard", metrics: FTestWeb.Telemetry

    end
  end

  # Enables the Swoosh mailbox preview in development.
  #
  # Note that preview only shows emails that were sent by the same
  # node running the Phoenix server.
  if Mix.env() == :dev do
    scope "/dev" do
      pipe_through :browser

      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
