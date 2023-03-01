defmodule WitchspaceDiscord.Dice.Interactions.ThrowShort do
  @moduledoc """
  Handles /roll slash command
  """
  use WitchspaceDiscord.Interaction

  alias Witchspace.Dice

  @impl InteractionBehaviour
  def get_command do
    command("t")
    |> with_desc("Quickly throw 2D against 8+")
  end

  @impl InteractionBehaviour
  def handle_interaction(_interaction, _options) do
    {:ok, msg} = Dice.throw(8, 0, "over")

    respond(msg)
  end
end
