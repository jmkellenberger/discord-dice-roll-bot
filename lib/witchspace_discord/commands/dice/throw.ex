defmodule WitchspaceDiscord.Commands.Throw do
  @name "throw"
  @description "Throws 2d6 against a target number."

  use WitchspaceDiscord.Interaction

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

  @impl Nosedrum.ApplicationCommand
  def command(interaction) do
    target = Helpers.fetch_opt(interaction, "target", 8)
    modifier = Helpers.fetch_opt(interaction, "modifier", 0)
    under = Helpers.fetch_opt(interaction, "roll_under", false)

    case Droll.roll("2d6" <> Helpers.Dice.format_dice_modifier(modifier)) do
      {:ok, roll} ->
        result =
          if Helpers.Dice.throw_success?(roll, target, under) do
            "Success"
          else
            "Failure"
          end

        [
          content: "#{result} vs Target: #{target}. #{Helpers.Dice.format_roll(roll)}",
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
