defmodule WitchspaceDiscord.Dice.Interactions.RollHidden do
  @moduledoc """
  Handles /rpriv slash command
  """
  use WitchspaceDiscord.Interaction
  alias WitchspaceDiscord.Dice.Interactions.Roll

  @impl InteractionBehaviour
  def get_command do
    Roll.get_command()
    |> with_name("rpriv")
    |> with_desc("Privately rolls a dice expression")
  end

  @impl InteractionBehaviour
  def handle_interaction(interaction, options) do
    Roll.handle_interaction(interaction, options)
    |> private()
  end
end
