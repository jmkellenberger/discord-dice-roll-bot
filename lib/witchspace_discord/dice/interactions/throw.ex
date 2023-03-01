defmodule WitchspaceDiscord.Dice.Interactions.Throw do
  @moduledoc """
  Handles /throw slash command
  """
  use WitchspaceDiscord.Interaction

  alias WitchspaceDiscord.Dice.Helpers

  @impl InteractionBehaviour
  def get_command do
    new_command("throw")
    |> with_desc("Throws 2D against a target number")
    |> with_option(target())
    |> with_option(modifier())
    |> with_option(type())
  end

  defp target do
    new_option("target", :int)
    |> with_desc("Target number to roll against.")
    |> required()
  end

  defp modifier do
    new_option("modifier", :int)
    |> with_desc("The dice modifier, if any")
  end

  defp type() do
    new_option("type", :str)
    |> with_desc("The type of throw")
    |> with_choice("Over", "over")
    |> with_choice("Under", "under")
  end

  @impl InteractionBehaviour
  def handle_interaction(_interaction, options) do
    {target, _autocomplete} = get_option(options, "target")

    modifier =
      case get_option(options, "modifier") do
        {dm, _autocomplete} -> dm
        nil -> 0
      end

    type =
      case get_option(options, "type") do
        {dm, _autocomplete} -> dm
        nil -> "over"
      end

    case Helpers.handle_dice_throw(target, modifier, type) do
      {:ok, msg} ->
        respond()
        |> with_content(msg)

      {:error, err} ->
        respond()
        |> with_content(err)
        |> private()
    end
  end
end
