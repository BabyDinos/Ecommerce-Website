defmodule Ecommercewebsite.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Telemetry supervisor
      EcommercewebsiteWeb.Telemetry,
      # Start the Ecto repository
      Ecommercewebsite.Repo,
      # Start the PubSub system
      {Phoenix.PubSub, name: Ecommercewebsite.PubSub},
      # Start Finch
      {Finch, name: Ecommercewebsite.Finch},
      # Start the Endpoint (http/https)
      EcommercewebsiteWeb.Endpoint
      # Start a worker by calling: Ecommercewebsite.Worker.start_link(arg)
      # {Ecommercewebsite.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Ecommercewebsite.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    EcommercewebsiteWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
