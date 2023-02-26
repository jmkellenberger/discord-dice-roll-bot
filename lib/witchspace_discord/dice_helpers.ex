defmodule WitchspaceDiscord.DiceHelpers do
  @spec format_dice_modifier(mod :: integer() | Droll.Result.t()) :: String.t()
  def format_dice_modifier(%Droll.Result{modifier: mod}),
    do: format_dice_modifier(mod)

  def format_dice_modifier(mod) when mod > 0, do: " + #{mod}"
  def format_dice_modifier(mod) when mod < 0, do: " - #{abs(mod)}"
  def format_dice_modifier(0), do: ""

  def format_roll(%Droll.Result{} = roll) do
    "Rolled #{roll.formula}, got: **#{roll.total}** (#{Enum.join(roll.rolls, " + ")}#{format_dice_modifier(roll)})"
  end
end
