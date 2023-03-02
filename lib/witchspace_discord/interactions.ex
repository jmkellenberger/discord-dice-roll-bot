defmodule WitchspaceDiscord.Interactions do
  @moduledoc """
  Register slash commands and handles interactions
  """

  require Logger
  alias Nostrum.Api
  alias Nostrum.Struct.Interaction

  alias WitchspaceDiscord.Common.Interactions.{About, Help, Thank}
  alias WitchspaceDiscord.Campaign.Interactions.Campaign

  alias WitchspaceDiscord.Dice.Interactions.{
    Roll,
    RollHidden,
    Throw,
    ThrowHidden
  }

  @commands [
    About,
    Campaign,
    Help,
    Roll,
    RollHidden,
    Thank,
    Throw,
    ThrowHidden
  ]

  @spec list_commands :: [module]
  def list_commands, do: @commands

  @spec register_commands(guilds :: [Nostrum.Struct.Guild.t()]) ::
          {:ok, [map]} | {:error, [map]}
  def register_commands(guilds) do
    @commands
    |> Enum.map(& &1.get_command())
    |> Enum.reject(&is_nil/1)
    |> register_commands(guilds, Application.get_env(:witchspace, :env))
  end

  defp register_commands(commands, _guilds, :prod) do
    Api.bulk_overwrite_global_application_commands(commands)
  end

  defp register_commands(commands, guilds, _env) do
    for guild <- guilds,
        do: Api.bulk_overwrite_guild_application_commands(guild.id, commands)
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
      data = parse_interaction_data(interaction.data)
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

  defp call_interaction(interaction, {"campaign", opt}),
    do: Campaign.handle_interaction(interaction, opt)

  defp call_interaction(interaction, {"help", opt}),
    do: Help.handle_interaction(interaction, opt)

  defp call_interaction(interaction, {"roll", opt}),
    do: Roll.handle_interaction(interaction, opt)

  defp call_interaction(interaction, {"rpriv", opt}),
    do: RollHidden.handle_interaction(interaction, opt)

  defp call_interaction(interaction, {"thank", opt}),
    do: Thank.handle_interaction(interaction, opt)

  defp call_interaction(interaction, {"throw", opt}),
    do: Throw.handle_interaction(interaction, opt)

  defp call_interaction(interaction, {"tpriv", opt}),
    do: ThrowHidden.handle_interaction(interaction, opt)

  defp call_interaction(_interaction, _data),
    do: raise("Unknown command")

  defp parse_interaction_data(interaction_data) when is_binary(interaction_data.custom_id) do
    [command_string, options_string] = String.split(interaction_data.custom_id, "|")

    options =
      String.split(options_string, ":")
      |> Enum.chunk_every(2)
      |> Enum.reduce([], fn [name, value], acc ->
        acc ++ [%{name: name, value: value, focused: false}]
      end)

    {command_string, options}
  end

  defp parse_interaction_data(interaction_data) do
    options = parse_list_of_options(interaction_data.options)

    {interaction_data.name, options}
  end

  defp parse_list_of_options(options) when is_nil(options), do: []

  defp parse_list_of_options(options) do
    Enum.flat_map(options, fn option ->
      case option.type do
        1 -> parse_sub_command(option)
        _ -> [parse_data_option(option)]
      end
    end)
  end

  defp parse_sub_command(option) do
    [%{name: option.name, value: "", focused: false}] ++ parse_list_of_options(option.options)
  end

  defp parse_data_option(option) do
    %{
      name: option.name,
      value: option.value,
      focused: if(is_nil(Map.get(option, :focused)), do: false, else: option.focused)
    }
  end
end
