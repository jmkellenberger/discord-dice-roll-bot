defmodule WitchspaceDiscord.Interactions do
  @moduledoc """
  Register slash commands and handles interactions
  """

  require Logger
  alias Nostrum.Api
  alias Nostrum.Struct.Interaction

  alias WitchspaceDiscord.Common.Interactions.{About, Help}
  alias WitchspaceDiscord.Dice.Interactions.{Roll}
  alias WitchspaceDiscord.Helpers

  @spec list_commands :: any()
  def list_commands do
    [About, Help, Roll]
    |> Enum.map(& &1.get_command())
  end

  @spec register_commands() :: any()
  def register_commands do
    list_commands()
    |> Enum.reject(&is_nil/1)
    |> register_commands(Application.get_env(:witchspace, :env))
  end

  defp register_commands(commands, :prod) do
    Api.bulk_overwrite_global_application_commands(commands)
  end

  defp register_commands(commands, _env) do
    case Application.fetch_env(:witchspace, :guild1) do
      {:ok, guild_id} -> Api.bulk_overwrite_guild_application_commands(guild_id, commands)
      _ -> :noop
    end
  end

  @spec handle_interaction(Interaction.t()) :: any()
  def handle_interaction(interaction) do
    Logger.metadata(
      interaction_data: interaction.data,
      guild_id: interaction.guild_id,
      channel_id: interaction.channel_id,
      user_id: interaction.member && interaction.member.user.id
    )

    Logger.info("Interaction received")

    try do
      data = Helpers.parse_interaction_data(interaction.data)
      response = call_interaction(interaction, data)

      Nostrum.Api.create_interaction_response(interaction, response)
    rescue
      err ->
        Logger.error(err)

        Nostrum.Api.create_interaction_response(interaction, %{
          type: 4,
          data: %{content: "Something went wrong :("}
        })
    end
  end

  defp call_interaction(interaction, {"about", opt}),
    do: About.handle_interaction(interaction, opt)

  defp call_interaction(interaction, {"help", opt}),
    do: Help.handle_interaction(interaction, opt)

  defp call_interaction(interaction, {"roll", opt}),
    do: Roll.handle_interaction(interaction, opt)

  defp call_interaction(_interaction, _data),
    do: raise("Unknown command")
end
