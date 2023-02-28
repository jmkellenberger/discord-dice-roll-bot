defmodule WitchspaceDiscord.Dice.Interactions.HiddenThrow do
  @moduledoc """
  Handles /tpriv slash command
  """
  use WitchspaceDiscord.Interaction

  alias WitchspaceDiscord.Dice.Interactions.Throw

  @impl InteractionBehaviour
  @spec get_command() :: ApplicationCommand.application_command_map()
  def get_command,
    do: %{
      Throw.get_command()
      | name: "tpriv",
        description: "Privately throws 2D against a target number."
    }

  @impl InteractionBehaviour
  @spec handle_interaction(Interaction.t(), InteractionBehaviour.interaction_options()) :: map()
  def handle_interaction(interaction, options) do
    Throw.handle_interaction(interaction, options)
    |> private()
  end
end
