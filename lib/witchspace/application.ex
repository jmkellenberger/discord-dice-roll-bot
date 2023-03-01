defmodule Witchspace.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children =
      [
        WitchspaceWeb.Telemetry,
        Witchspace.Repo,
        {Phoenix.PubSub, name: Witchspace.PubSub},
        {Finch, name: Witchspace.Finch},
        WitchspaceWeb.Endpoint
      ]
      |> start_bot(Application.get_env(:witchspace, :env))

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Witchspace.Supervisor]
    Supervisor.start_link(children, opts)
  end

  defp start_bot(children, :test), do: children
  defp start_bot(children, _env), do: children ++ [WitchspaceDiscord.Supervisor]

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    WitchspaceWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
