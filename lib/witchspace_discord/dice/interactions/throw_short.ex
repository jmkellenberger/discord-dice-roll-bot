defmodule WitchspaceDiscord.Dice.Interactions.ThrowShort do
  @moduledoc """
  Handles /roll slash command
  """
  use WitchspaceDiscord.Interaction

  alias WitchspaceDiscord.Dice.Helpers

  @impl InteractionBehaviour
  def get_command,
    do: %{
      name: "t",
      description: "Quickly throw 2d6 against 8+"
    }

  @impl InteractionBehaviour
  def handle_interaction(_interaction, _options) do
    {:ok, msg} = Helpers.handle_dice_throw(8, 0, "over")

    respond()
    |> with_content(msg)
  end
end
