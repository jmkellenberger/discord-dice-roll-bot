defmodule WitchspaceDiscord.Dice.Interactions.Throw do
  @moduledoc """
  Handles /throw slash command
  """
  use WitchspaceDiscord.Interaction

  alias WitchspaceDiscord.Dice

  @impl InteractionBehaviour
  def get_command do
    command("throw")
    |> with_desc("Throws 2D against a target number")
    |> with_options(Dice.throw_opts())
  end

  @impl InteractionBehaviour
  def handle_interaction(interaction, options) do
    Dice.handle_throw(interaction, options)
  end
end
