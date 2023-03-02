defmodule WitchspaceDiscord.Dice.Interactions.Throw do
  @moduledoc """
  Handles /throw slash command
  """
  @name "throw"
  @description "Throws 2D against a target number"

  use WitchspaceDiscord.Interaction
  alias WitchspaceDiscord.Dice

  @impl Interaction
  def options, do: Dice.throw_opts()

  @impl Interaction
  def handle_interaction(_interaction, options), do: Dice.handle_throw(options)
end
