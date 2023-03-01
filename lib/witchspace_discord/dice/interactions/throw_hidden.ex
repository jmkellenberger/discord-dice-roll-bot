defmodule WitchspaceDiscord.Dice.Interactions.ThrowHidden do
  @moduledoc """
  Handles /tpriv slash command
  """
  use WitchspaceDiscord.Interaction

  alias WitchspaceDiscord.Dice

  @impl InteractionBehaviour
  def get_command do
    command("tpriv")
    |> with_desc("Privately throws 2D against a target number.")
    |> with_options(Dice.throw_opts())
  end

  @impl InteractionBehaviour
  def handle_interaction(interaction, options) do
    Dice.handle_throw(interaction, options)
    |> private()
  end
end
