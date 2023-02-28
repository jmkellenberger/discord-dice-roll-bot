defmodule WitchspaceDiscord.Dice.Interactions.Roll do
  @moduledoc """
  Handles /roll slash command
  """
  use WitchspaceDiscord.Interaction

  alias WitchspaceDiscord.Dice.Helpers

  @impl InteractionBehaviour
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
  def handle_interaction(_interaction, options) do
    dice =
      case get_option(options, "dice") do
        {dice, _autocomplete} -> dice
        nil -> "2d6"
      end

    case Helpers.handle_dice_roll(dice) do
      {:ok, msg} ->
        respond()
        |> with_content(msg)

      {:error, msg} ->
        respond()
        |> with_content(msg)
        |> private()
    end
  end
end
