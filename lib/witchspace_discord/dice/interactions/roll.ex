defmodule WitchspaceDiscord.Dice.Interactions.Roll do
  @moduledoc """
  Handles /roll slash command
  """
  use WitchspaceDiscord.Interaction

  alias WitchspaceDiscord.Dice

  @impl InteractionBehaviour
  def get_command do
    command("roll")
    |> with_desc("Rolls a dice expression.")
    |> with_option(Dice.dice_input())
  end

  @impl InteractionBehaviour
  def handle_interaction(interaction, options) do
    Dice.handle_roll(interaction, options)
  end
end
