defmodule WitchspaceDiscord.Dice.Interactions.RollShort do
  @moduledoc """
  Handles /roll slash command
  """
  use WitchspaceDiscord.Interaction

  alias Witchspace.Dice

  @impl InteractionBehaviour
  def get_command do
    command("r")
    |> with_desc("Quickly roll 2D")
  end

  @impl InteractionBehaviour
  def handle_interaction(_interaction, _options) do
    {:ok, msg} = Dice.parse("2d6")

    respond(msg)
  end
end
