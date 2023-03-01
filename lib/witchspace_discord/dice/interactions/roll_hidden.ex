defmodule WitchspaceDiscord.Dice.Interactions.RollHidden do
  @moduledoc """
  Handles /rpriv slash command
  """
  use WitchspaceDiscord.Interaction
  alias WitchspaceDiscord.Dice

  @impl InteractionBehaviour
  def get_command do
    command("rpriv")
    |> with_desc("Privately rolls a dice expression")
    |> with_option(Dice.dice_input())
  end

  @impl InteractionBehaviour
  def handle_interaction(interaction, options) do
    Dice.handle_roll(interaction, options)
    |> private()
  end
end
