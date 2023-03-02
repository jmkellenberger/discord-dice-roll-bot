defmodule WitchspaceDiscord.Dice.Interactions.Roll do
  @moduledoc """
  Handles /roll slash command
  """
  @name "roll"
  @description "Rolls a dice expression."

  use WitchspaceDiscord.Interaction
  alias WitchspaceDiscord.Dice

  @impl Interaction
  def options, do: Dice.dice_input()

  @impl Interaction
  def handle_interaction(_interaction, options), do: Dice.handle_roll(options)
end
