defmodule WitchspaceDiscord.Commands.Throw do
  alias WitchspaceDiscord.DiceHelpers

  @behaviour Nosedrum.ApplicationCommand
  use WitchspaceDiscord.SlashCommand

  @impl WitchspaceDiscord.SlashCommand
  def name, do: "throw"

  @impl Nosedrum.ApplicationCommand
  def description() do
    "Throws 2d6 against a target number."
  end

  @impl Nosedrum.ApplicationCommand
  def command(interaction) do
    target = fetch_opt(interaction, "target", 8)
    modifier = fetch_opt(interaction, "modifier", 0)
    under = fetch_opt(interaction, "roll_under", false)

    case Droll.roll("2d6" <> DiceHelpers.format_dice_modifier(modifier)) do
      {:ok, roll} ->
        [
          content: "#{throw_success?(roll, target, under)} #{DiceHelpers.format_roll(roll)}",
          ephemeral?: fetch_opt(interaction, "private", false)
        ]

      {:error, err} ->
        [
          content: err,
          ephemeral?: true
        ]
    end
  end

  def throw_success?(roll, target, false) do
    if roll.total >= target do
      "Success vs Target: #{target}!"
    else
      "Failure vs Target: #{target}."
    end
  end

  def throw_success?(roll, target, true) do
    if roll.total <= target do
      "Success vs Target: #{target}!"
    else
      "Failure vs Target: #{target}."
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
        type: :integer,
        name: "target",
        description: "Target number to roll against. Default: 8.",
        required: false
      },
      %{
        type: :integer,
        name: "modifier",
        description: "Modifier to the roll",
        required: false
      },
      %{
        type: :boolean,
        name: "roll_under",
        description: "Roll less than or equal to instead?",
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
