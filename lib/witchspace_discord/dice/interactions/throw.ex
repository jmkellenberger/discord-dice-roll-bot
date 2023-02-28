defmodule WitchspaceDiscord.Dice.Interactions.Throw do
  @moduledoc """
  Handles /throw slash command
  """
  use WitchspaceDiscord.Interaction

  alias WitchspaceDiscord.Dice.Helpers

  @impl InteractionBehaviour
  @spec get_command() :: ApplicationCommand.application_command_map()
  def get_command,
    do: %{
      name: "throw",
      description: "Throws 2D against a target number.",
      options: [
        %{
          type: 4,
          name: "target",
          description: "The target number to roll against.",
          required: true
        },
        %{
          type: 4,
          name: "modifier",
          description: "The dice modifier"
        },
        %{
          name: "type",
          description: "What type of throw",
          type: 3,
          choices: [
            %{
              name: "Over",
              value: "over"
            },
            %{
              name: "Under",
              value: "under"
            }
          ]
        }
      ]
    }

  @impl InteractionBehaviour
  @spec handle_interaction(Interaction.t(), InteractionBehaviour.interaction_options()) :: map()
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
