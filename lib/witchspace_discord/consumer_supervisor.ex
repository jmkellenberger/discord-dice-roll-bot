defmodule WitchspaceDiscord.ConsumerSupervisor do
  use Supervisor

  def start_link(args) do
    Supervisor.start_link(__MODULE__, args, name: __MODULE__)
  end

  @impl true
  def init(_args) do
    children =
      for n <- 1..System.schedulers_online(),
          do:
            Supervisor.child_spec({WitchspaceDiscord.Consumer, []},
              id: {:witchspace_discord, :consumer, n}
            )

    Supervisor.init(children, strategy: :one_for_one)
  end
end
