defmodule WitchspaceDiscord.Dice.Interactions.RollShort do
  @moduledoc """
  Handles /roll slash command
  """
  use WitchspaceDiscord.Interaction

  alias WitchspaceDiscord.Dice.Helpers

  @impl InteractionBehaviour
  def get_command do
    new_command("r")
    |> with_desc("Quickly roll 2D")
  end

  @impl InteractionBehaviour
  def handle_interaction(_interaction, _options) do
    {:ok, msg} = Helpers.handle_dice_roll("2d6")

    respond()
    |> with_content(msg)
  end
end
