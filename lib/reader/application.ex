defmodule Reader.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Telemetry supervisor
      ReaderWeb.Telemetry,
      # Start the Ecto repository
      # Reader.Repo,
      # Start the PubSub system
      {Phoenix.PubSub, name: Reader.PubSub},
      # Start Finch
      {Finch, name: Reader.Finch},
      # Start the Endpoint (http/https)
      ReaderWeb.Endpoint
      # Start a worker by calling: Reader.Worker.start_link(arg)
      # {Reader.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Reader.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    ReaderWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
