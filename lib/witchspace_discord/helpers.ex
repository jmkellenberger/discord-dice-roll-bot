defmodule WitchspaceDiscord.Helpers do
  alias Nostrum.Struct.Interaction
  @app "WitchspaceDiscord"
  @command_module "Commands"

  def fetch_campaign(guild_id) do
    case Witchspace.Campaigns.get_campaign_by_guild_id(guild_id) do
      %Witchspace.Campaigns.Campaign{} = campaign -> {:ok, campaign}
      nil -> {:error, "Campaign not found for guild: ##{guild_id}."}
    end
  end

  def fetch_opt(interaction, opt, default \\ nil)

  def fetch_opt(%Interaction{data: %{options: nil}}, _opt, default),
    do: default

  def fetch_opt(
        %Interaction{data: %{options: opts}},
        opt,
        default
      ) do
    opts
    |> Enum.filter(&(&1.name == opt))
    |> List.first(%{})
    |> Map.get(:value, default)
  end

  def list_command_modules() do
    with {:ok, list} <- :application.get_key(:witchspace, :modules) do
      list
      |> Enum.filter(&match?([@app, @command_module, _], &1 |> Module.split() |> Enum.take(3)))
    end
  end

  def format_date(%{day: day, year: year}) do
    "#{day}-#{year}"
  end

  def format_changeset_errors(%Ecto.Changeset{errors: errors}) do
    Enum.map(errors, fn {k, {msg, _}} -> "**#{Phoenix.Naming.humanize(k)}**: #{msg}" end)
    |> Enum.join("\n")
  end
end
