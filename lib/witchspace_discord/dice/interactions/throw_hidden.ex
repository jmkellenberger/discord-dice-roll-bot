defmodule WitchspaceDiscord.Dice.Interactions.ThrowHidden do
  @moduledoc """
  Handles /tpriv slash command
  """
  @name "tpriv"
  @description "Privately throws 2D against a target number."

  use WitchspaceDiscord.Interaction

  alias WitchspaceDiscord.Dice

  @impl Interaction
  def options, do: Dice.throw_opts()

  @impl Interaction
  def handle_interaction(_interaction, options),
    do: private(Dice.handle_throw(options))
end
