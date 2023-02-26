defmodule WitchspaceDiscord.Commands.Roll do
  alias WitchspaceDiscord.DiceHelpers

  @behaviour Nosedrum.ApplicationCommand
  use WitchspaceDiscord.SlashCommand

  @impl WitchspaceDiscord.SlashCommand
  def name, do: "roll"

  @impl Nosedrum.ApplicationCommand
  def description() do
    "Rolls dice from a valid dice expression, like 2d6+3"
  end

  @impl Nosedrum.ApplicationCommand
  def command(interaction) do
    case Droll.roll(fetch_opt(interaction, "dice", "2d6")) do
      {:ok, roll} ->
        [
          content:
            "Rolled #{roll.formula}, got: **#{roll.total}** (#{Enum.join(roll.rolls, " + ")}#{DiceHelpers.format_dice_modifier(roll)})",
          ephemeral?: fetch_opt(interaction, "private", false)
        ]

      {:error, err} ->
        [
          content: err,
          ephemeral?: true
        ]
    end
  end

  @impl Nosedrum.ApplicationCommand
  def type() do
    :slash
  end

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
end
