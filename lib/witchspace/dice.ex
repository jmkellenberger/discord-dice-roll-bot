defmodule Witchspace.Dice do
  @moduledoc """
  Dice formatting and rolling helpers
  """
  @spec format_dice_modifier(mod :: integer() | Droll.Result.t()) :: String.t()
  def format_dice_modifier(%Droll.Result{modifier: mod}),
    do: format_dice_modifier(mod)

  def format_dice_modifier(mod) when mod > 0, do: " + #{mod}"
  def format_dice_modifier(mod) when mod < 0, do: " - #{abs(mod)}"
  def format_dice_modifier(0), do: ""

  def format_roll(%Droll.Result{} = roll) do
    "Rolled #{roll.formula}, got: **#{roll.total}** (#{Enum.join(roll.rolls, " + ")}#{format_dice_modifier(roll)})"
  end

  def throw_success?(roll, target, "over"), do: roll.total >= target
  def throw_success?(roll, target, "under"), do: roll.total <= target

  def parse(dice) do
    case Droll.roll(dice) do
      {:ok, roll} ->
        {:ok, format_roll(roll)}

      {:error, _} ->
        {:error, "Invalid input. Expected expression such as: 2d6, 1d20, 3d6-1. Got #{dice}."}
    end
  end

  def throw(target, modifier, type) do
    case Droll.roll("2d6" <> format_dice_modifier(modifier)) do
      {:ok, roll} ->
        result =
          if throw_success?(roll, target, type) do
            "Success"
          else
            "Failure"
          end

        sign =
          case type do
            "over" -> "#{target}+"
            "under" -> "#{target}-"
          end

        {:ok, "#{result} vs Target: #{sign}. #{format_roll(roll)}"}

      err ->
        err
    end
  end
end
