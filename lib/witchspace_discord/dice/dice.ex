defmodule WitchspaceDiscord.Dice do
  @moduledoc """
  Common option and response builders for dice commands
  """
  alias Witchspace.Dice
  import WitchspaceDiscord.Interaction.{Command, Response}

  def dice_input do
    option(
      "dice",
      "The dice expression to roll. Ex: 2d6+3",
      :str
    )
  end

  def throw_opts do
    [
      target_input(),
      modifier_input(),
      type_input()
    ]
  end

  def target_input do
    required_option(
      "target",
      "Target number to roll against.",
      :int
    )
  end

  def modifier_input do
    option(
      "modifier",
      "The dice modifier, if any",
      :int
    )
  end

  def type_input do
    option(
      "type",
      "The type of throw",
      :str,
      [~w/Over Under/]
    )
  end

  def handle_roll(options) do
    dice =
      case get_option(options, "dice") do
        {dice, _autocomplete} -> dice
        nil -> "2d6"
      end

    case Dice.parse(dice) do
      {:ok, msg} ->
        response(msg)

      {:error, msg} ->
        msg
        |> response()
        |> private()
    end
  end

  def handle_throw(options) do
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

    case Dice.throw(target, modifier, type) do
      {:ok, msg} ->
        response(msg)

      {:error, err} ->
        err
        |> response()
        |> private()
    end
  end
end
