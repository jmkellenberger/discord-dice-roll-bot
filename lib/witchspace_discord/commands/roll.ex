defmodule WitchspaceDiscord.Commands.Roll do
  @name "roll"
  @description "Rolls dice from a valid dice expression, like 2d6+3"

  use WitchspaceDiscord.Interaction

  @impl Nosedrum.ApplicationCommand
  def options() do
    [
      %{
        type: :string,
        name: "dice",
        description: "The dice expression to roll.",
        required: false
      },
      %{
        type: :boolean,
        name: "private",
        description: "Keep the result private?",
        required: false
      }
    ]
  end

  @impl Nosedrum.ApplicationCommand
  def command(interaction) do
    case Droll.roll(Helpers.fetch_opt(interaction, "dice", "2d6")) do
      {:ok, roll} ->
        [
          content: Helpers.Dice.format_roll(roll),
          ephemeral?: Helpers.fetch_opt(interaction, "private", false)
        ]

      {:error, err} ->
        [
          content: err,
          ephemeral?: true
        ]
    end
  end
end
