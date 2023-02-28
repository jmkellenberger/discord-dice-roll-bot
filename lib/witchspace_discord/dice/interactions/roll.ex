defmodule WitchspaceDiscord.Dice.Interactions.Roll do
  @moduledoc """
  Handles /help slash command
  """
  use WitchspaceDiscord.Interaction

  alias WitchspaceDiscord.{Helpers, Dice}

  @impl InteractionBehaviour
  @spec get_command() :: ApplicationCommand.application_command_map()
  def get_command,
    do: %{
      name: "roll",
      description: "Rolls a dice expression",
      options: [
        %{
          type: 3,
          name: "dice",
          description: "The dice expression to roll. Ex. 2d6+3"
        }
      ]
    }

  @impl InteractionBehaviour
  @spec handle_interaction(Interaction.t(), InteractionBehaviour.interaction_options()) :: map()
  def handle_interaction(_interaction, options) do
    dice =
      case get_option(options, "dice") do
        {dice, _autocomplete} -> dice
        nil -> "2d6"
      end

    msg =
      case Droll.roll(dice) do
        {:ok, roll} ->
          Dice.Helpers.format_roll(roll)

        {:error, _} ->
          "Invalid input. Expected expression such as: 2d6, 1d20, 3d6-1. Got #{dice}."
      end

    respond()
    |> with_content(msg)
  end
end
