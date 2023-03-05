defmodule Asema.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children =
      for n <- 1..System.schedulers_online(),
          do:
            Supervisor.child_spec({Asema.Consumer, []},
              id: {:witchspace_discord, :consumer, n}
            )

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Asema.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
