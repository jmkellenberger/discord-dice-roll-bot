defmodule WitchspaceDiscord.Commands.NewCampaign do
  @name "new_campaign"
  @description "Registers a campaign for the discord server."

  use WitchspaceDiscord.Interaction

  @impl Nosedrum.ApplicationCommand
  def options() do
    [
      %{
        type: :string,
        name: "name",
        description: "The campaign name",
        required: true,
        min_length: 2
      },
      %{
        type: :integer,
        name: "day",
        description: "Starting day for the campaign's in game calendar",
        required: true,
        min_value: 1
      },
      %{
        type: :integer,
        name: "year",
        description: "Starting year for the campaign's in game calendar",
        required: true,
        min_value: 1
      },
      %{
        type: :integer,
        name: "year-length",
        description: "Year length for the campaign's in game calendar. Default: 365",
        required: false,
        min_value: 1
      }
    ]
  end

  @impl Nosedrum.ApplicationCommand
  def command(%{guild_id: guild_id} = interaction) do
    case Witchspace.Campaigns.get_campaign_by_guild_id(guild_id) do
      nil ->
        content =
          with {:ok, campaign} <- Witchspace.Campaigns.create_campaign(get_opts(interaction)) do
            "Success! Campaign: #{campaign.name} initialized. The current date is **#{Witchspace.Campaigns.get_date(campaign) |> Helpers.format_date()}**."
          else
            {:error, changeset} -> Helpers.format_changeset_errors(changeset)
          end

        [
          content: content,
          ephemeral?: true
        ]

      campaign ->
        "Campaign: #{campaign.name} already exists for this guild."
    end
  end

  defp get_opts(interaction) do
    %{
      guild_id: interaction.guild_id,
      name: Helpers.fetch_opt(interaction, "name"),
      date:
        Witchspace.Campaigns.date_to_days(
          Helpers.fetch_opt(interaction, "day"),
          Helpers.fetch_opt(interaction, "year"),
          Helpers.fetch_opt(interaction, "year-length", 365)
        ),
      year_length: Helpers.fetch_opt(interaction, "year-length")
    }
  end
end
