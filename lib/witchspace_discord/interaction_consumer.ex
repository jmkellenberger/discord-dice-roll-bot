defmodule WitchspaceDiscord.InteractionConsumer do
  use Nostrum.Consumer

  @guild_id Application.compile_env(:witchspace, :test_guild)

  def start_link do
    Consumer.start_link(__MODULE__)
  end

  def handle_event({:READY, _data, _ws_state}) do
    register_commands(@guild_id)
  end

  def handle_event({:INTERACTION_CREATE, interaction, _ws_state}) do
    Nosedrum.Interactor.Dispatcher.handle_interaction(interaction)
  end

  def handle_event(_data) do
    :noop
  end

  defp register_commands(guild_id) do
    with {:ok, list} <- :application.get_key(:witchspace, :modules) do
      list
      |> Enum.filter(
        &match?(["WitchspaceDiscord", "Commands", _], &1 |> Module.split() |> Enum.take(3))
      )
      |> Enum.each(fn m -> apply(m, :register, [guild_id]) end)
    end
  end
end
