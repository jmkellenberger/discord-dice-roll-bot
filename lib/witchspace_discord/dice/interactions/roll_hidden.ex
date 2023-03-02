defmodule WitchspaceDiscord.Dice.Interactions.RollHidden do
  @moduledoc """
  Handles /rpriv slash command
  """
  @name "rpriv"
  @description "Privately rolls a dice expression."

  alias WitchspaceDiscord.Dice
  use WitchspaceDiscord.Interaction

  @impl Interaction
  def options, do: Dice.dice_input()

  @impl Interaction
  def handle_interaction(_interaction, options),
    do: private(Dice.handle_roll(options))
end
