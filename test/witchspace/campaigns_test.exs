defmodule Witchspace.CampaignsTest do
  use Witchspace.DataCase

  alias Witchspace.Campaigns

  describe "campaigns" do
    alias Witchspace.Campaigns.Campaign

    import Witchspace.CampaignsFixtures

    @invalid_attrs %{date: nil, guild_id: nil, name: nil, year_length: nil}

    @valid_attrs %{
      date: 42,
      year_length: 42,
      guild_id: 42,
      name: "some name"
    }

    @update_attrs %{date: 43, guild_id: 43, name: "some updated name", year_length: 43}

    test "list_campaigns/0 returns all campaigns" do
      campaign = campaign_fixture()
      assert Campaigns.list_campaigns() == [campaign]
    end

    test "get_campaign!/1 returns the campaign with given id" do
      campaign = campaign_fixture()
      assert Campaigns.get_campaign!(campaign.id) == campaign
    end

    test "create_campaign/1 with valid data creates a campaign" do
      assert {:ok, %Campaign{} = campaign} = Campaigns.create_campaign(@valid_attrs)
      assert campaign.date == 42
      assert campaign.guild_id == 42
      assert campaign.name == "some name"
      assert campaign.year_length == 42
    end

    test "create_campaign/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Campaigns.create_campaign(@invalid_attrs)
    end

    test "update_campaign/2 with valid data updates the campaign" do
      campaign = campaign_fixture()

      assert {:ok, %Campaign{} = campaign} = Campaigns.update_campaign(campaign, @update_attrs)
      assert campaign.date == 43
      assert campaign.guild_id == 43
      assert campaign.name == "some updated name"
      assert campaign.year_length == 43
    end

    test "update_campaign/2 with invalid data returns error changeset" do
      campaign = campaign_fixture()
      assert {:error, %Ecto.Changeset{}} = Campaigns.update_campaign(campaign, @invalid_attrs)
      assert campaign == Campaigns.get_campaign!(campaign.id)
    end

    test "delete_campaign/1 deletes the campaign" do
      campaign = campaign_fixture()
      assert {:ok, %Campaign{}} = Campaigns.delete_campaign(campaign)
      assert_raise Ecto.NoResultsError, fn -> Campaigns.get_campaign!(campaign.id) end
    end

    test "change_campaign/1 returns a campaign changeset" do
      campaign = campaign_fixture()
      assert %Ecto.Changeset{} = Campaigns.change_campaign(campaign)
    end
  end
end
