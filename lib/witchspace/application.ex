defmodule Witchspace.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    opts = [strategy: :one_for_one, name: Witchspace.Supervisor]
    Supervisor.start_link(children(), opts)
  end

  defp children() do
    children = [
      WitchspaceWeb.Telemetry,
      Witchspace.Repo,
      {Phoenix.PubSub, name: Witchspace.PubSub},
      {Finch, name: Witchspace.Finch},
      WitchspaceWeb.Endpoint
    ]

    case Application.get_env(:witchspace, :env) do
      :test -> children
      _ -> children ++ [WitchspaceDiscord.Supervisor]
    end
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    WitchspaceWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
