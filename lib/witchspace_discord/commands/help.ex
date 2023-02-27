defmodule WitchspaceDiscord.Commands.Help do
  @name "help"
  @description "Displays a list of available commands."

  use WitchspaceDiscord.Interaction

  @impl Nosedrum.ApplicationCommand
  def command(_interaction) do
    [
      content:
        WitchspaceDiscord.Helpers.list_command_modules()
        |> Enum.map(&"**/#{&1.name()}**: #{&1.description()}")
        |> Enum.join("\n"),
      ephemeral?: true
    ]
  end
end
