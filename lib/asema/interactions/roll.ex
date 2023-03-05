defmodule Asema.Interactions.Roll do
  @moduledoc """
  Handles /roll slash command
  """
  @name "roll"
  @description "Rolls a dice expression."

  use Asema.Interaction

  @impl Interaction
  def options, do: dice_input()

  @impl Interaction
  def handle_interaction(_interaction, options) do
    dice =
      case get_option(options, "dice") do
        {dice, _autocomplete} -> dice
        nil -> "2d6"
      end

    case Troll.roll(dice) do
      {:ok, msg} ->
        msg
        |> to_string
        |> response()

      {:error, msg} ->
        msg
        |> response()
        |> private()
    end
  end

  def dice_input do
    option(
      "dice",
      "The dice expression to roll. Ex: 2d6+3",
      :str
    )
  end
end
