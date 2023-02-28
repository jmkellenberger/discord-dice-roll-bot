defmodule WitchspaceDiscord.Dice.Interactions.Roll do
  @moduledoc """
  Handles /roll slash command
  """
  use WitchspaceDiscord.Interaction

  alias WitchspaceDiscord.Dice.Helpers

  @impl InteractionBehaviour
  def get_command do
    new_command("roll")
    |> with_desc("Rolls a dice expression.")
    |> with_option(dice())
  end

  defp dice do
    new_option("dice", :str)
    |> with_desc("The dice expression to roll. Ex: 2d6+3")
  end

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
