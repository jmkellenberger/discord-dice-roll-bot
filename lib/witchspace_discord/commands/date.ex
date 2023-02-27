defmodule WitchspaceDiscord.Commands.Date do
  @name "date"
  @description "Displays the current campaign date."

  use WitchspaceDiscord.Interaction

  @impl Nosedrum.ApplicationCommand
  def command(%{guild_id: guild_id}) do
    [
      content:
        case Helpers.fetch_campaign(guild_id) do
          {:ok, campaign} ->
            campaign |> Witchspace.Campaigns.get_date() |> Helpers.format_date_verbose()

          {:error, err} ->
            err
        end,
      ephemeral?: true
    ]
  end
end
