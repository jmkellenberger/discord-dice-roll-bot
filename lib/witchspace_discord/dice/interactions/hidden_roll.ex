defmodule WitchspaceDiscord.Dice.Interactions.HiddenRoll do
  @moduledoc """
  Handles /rpriv slash command
  """
  use WitchspaceDiscord.Interaction
  alias WitchspaceDiscord.Dice.Interactions.Roll

  @impl InteractionBehaviour
  def get_command,
    do: %{Roll.get_command() | name: "rpriv", description: "Privately rolls a dice expression"}

  @impl InteractionBehaviour
  def handle_interaction(interaction, options) do
    Roll.handle_interaction(interaction, options)
    |> private()
  end
end
