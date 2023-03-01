defmodule WitchspaceDiscord.Dice do
  @moduledoc """
  Common option and response builders for dice commands
  """
  alias Witchspace.Dice
  import WitchspaceDiscord.{Command, Response}

  def dice_input do
    option("dice", :str)
    |> with_desc("The dice expression to roll. Ex: 2d6+3")
  end

  def throw_opts, do: [target_input(), modifier_input(), type_input()]

  def target_input do
    option("target", :int)
    |> with_desc("Target number to roll against.")
    |> required()
  end

  def modifier_input do
    option("modifier", :int)
    |> with_desc("The dice modifier, if any")
  end

  def type_input do
    option("type", :str)
    |> with_desc("The type of throw")
    |> with_choice("Over")
    |> with_choice("Under")
  end

  def handle_roll(_interaction, options) do
    dice =
      case get_option(options, "dice") do
        {dice, _autocomplete} -> dice
        nil -> "2d6"
      end

    case Dice.parse(dice) do
      {:ok, msg} ->
        respond(msg)

      {:error, msg} ->
        respond(msg)
        |> private()
    end
  end

  def handle_throw(_interaction, options) do
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
        respond(msg)

      {:error, err} ->
        respond(err)
        |> private()
    end
  end
end
