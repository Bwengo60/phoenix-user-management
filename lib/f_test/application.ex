defmodule FTest.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Ecto repository
      FTest.Repo,
      # Start the Telemetry supervisor
      FTestWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: FTest.PubSub},
      # Start the Endpoint (http/https)
      FTestWeb.Endpoint
      # Start a worker by calling: FTest.Worker.start_link(arg)
      # {FTest.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: FTest.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    FTestWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
