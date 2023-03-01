defmodule WitchspaceDiscord.Dice.Interactions.ThrowHidden do
  @moduledoc """
  Handles /tpriv slash command
  """
  use WitchspaceDiscord.Interaction

  alias WitchspaceDiscord.Dice.Interactions.Throw

  @impl InteractionBehaviour
  def get_command do
    Throw.get_command()
    |> with_name("tpriv")
    |> with_desc("Privately throws 2D against a target number.")
  end

  @impl InteractionBehaviour
  def handle_interaction(interaction, options) do
    Throw.handle_interaction(interaction, options)
    |> private()
  end
end
