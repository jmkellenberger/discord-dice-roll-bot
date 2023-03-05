defmodule Asema.Interactions.Check do
  @moduledoc """
  Handles /check slash command
  """
  @name "check"
  @description "Throws 2D against a target number"

  use Asema.Interaction

  @impl Interaction
  def options, do: throw_opts()

  defp throw_opts do
    [
      target_input(),
      modifier_input(),
      type_input()
    ]
  end

  defp target_input do
    required_option(
      "target",
      "Target number to roll against.",
      :int
    )
  end

  defp modifier_input do
    option(
      "modifier",
      "The dice modifier, if any",
      :int
    )
  end

  defp type_input do
    option(
      "type",
      "The type of check",
      :str,
      [~w/Over Under/]
    )
  end

  @impl Interaction
  def handle_interaction(_interaction, options) do
    target =
      case get_option(options, "modifier") do
        {dm, _autocomplete} -> dm
        nil -> 8
      end

    modifier =
      case get_option(options, "modifier") do
        {dm, _autocomplete} -> dm
        nil -> 0
      end

    type =
      case get_option(options, "type") do
        {"over", _autocomplete} -> :over
        {"under", _autocomplete} -> :under
        nil -> :over
      end

    Troll.check(target, modifier, type)
    |> to_string()
    |> response()
  end
end
