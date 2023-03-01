defmodule WitchspaceDiscord.Campaign.Interactions.Campaign do
  @moduledoc """
  Handles /campaign command group
  """

  use WitchspaceDiscord.Interaction

  @impl InteractionBehaviour
  def get_command,
    do: %{
      name: "campaign",
      description: "Campaign management commands",
      options: [
        %{
          name: "time",
          description: "View and manage campaign time",
          # 2 is type SUB_COMMAND_GROUP
          type: 2,
          options: [
            %{
              name: "now",
              description: "Displays current campaign date",
              # 1 is type SUB_COMMAND
              type: 1
            },
            %{
              name: "advance",
              description: "Advances time one day",
              type: 1
            }
          ]
        },
        %{
          name: "init",
          description: "initialize a new campaign",
          type: 1
        }
      ]
    }

  @impl InteractionBehaviour
  def handle_interaction(_interaction, _options) do
    respond("This feature isn't implemented yet!")
    |> private()
  end
end
