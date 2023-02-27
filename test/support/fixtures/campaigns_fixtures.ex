defmodule Witchspace.CampaignsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Witchspace.Campaigns` context.
  """

  @doc """
  Generate a campaign.
  """
  def campaign_fixture(attrs \\ %{}) do
    {:ok, campaign} =
      attrs
      |> Enum.into(%{
        date: 42,
        year_length: 42,
        guild_id: 42,
        name: "some name"
      })
      |> Witchspace.Campaigns.create_campaign()

    campaign
  end
end
