defmodule Asema.Consumer do
  @moduledoc """
  Consumes events from the Discord API websocket
  """

  require Logger
  use Nostrum.Consumer

  alias Asema.Interactions

  def start_link do
    Consumer.start_link(__MODULE__)
  end

  def handle_event({:READY, %{guilds: guilds}, _ws_state}) do
    Interactions.register_commands(guilds)

    version = to_string(Application.spec(:witchspace, :vsn))
    Nostrum.Api.update_status(:online, "on v#{version}")

    Logger.info("Bot started! v#{version}")
  end

  def handle_event({:GUILD_CREATE, {_guild}, _ws_state}) do
    # TODO: Store guild ID
  end

  def handle_event({:INTERACTION_CREATE, interaction, _ws_state}) do
    Interactions.handle_interaction(interaction)
  end

  def handle_event({_event, _data, _ws}) do
    :noop
  end
end
