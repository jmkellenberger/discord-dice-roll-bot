defmodule WitchspaceDiscord.Common.Interactions.Help do
  @moduledoc """
  Handles /help slash command
  """

  import Nostrum.Struct.Embed
  alias Nostrum.Struct.{ApplicationCommand, Interaction}

  alias WitchspaceDiscord.{Interactions, InteractionBehaviour}

  @behaviour InteractionBehaviour

  @impl InteractionBehaviour
  @spec get_command() :: ApplicationCommand.application_command_map()
  def get_command,
    do: %{
      name: "help",
      description: "Lists available slash commands"
    }

  @impl InteractionBehaviour
  @spec handle_interaction(Interaction.t(), InteractionBehaviour.interaction_options()) :: map()
  def handle_interaction(_interaction, _options) do
    embed =
      Enum.reduce(
        Interactions.list_commands(),
        put_title(%Nostrum.Struct.Embed{}, "Available Commands"),
        &put_field(&2, "/" <> &1.name, &1.description, false)
      )

    %{
      type: 4,
      data: %{embeds: [embed]}
    }
  end
end
