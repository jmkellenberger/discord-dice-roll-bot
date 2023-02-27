defmodule Witchspace.Campaigns.Campaign do
  use Ecto.Schema
  import Ecto.Changeset

  schema "campaigns" do
    field(:date, :integer, default: 1)
    field(:guild_id, :integer)
    field(:name, :string)
    field(:year_length, :integer, default: 365)
    has_many(:wallets, Witchspace.Economy.Wallet)

    timestamps()
  end

  @doc false
  def changeset(campaign, attrs) do
    campaign
    |> cast(attrs, [:name, :date, :year_length, :guild_id])
    |> validate_required([:name, :date, :year_length])
    |> validate_number(:date, greater_than: 0)
    |> validate_number(:year_length, greater_than: 1)
    |> unique_constraint(:guild_id)
  end
end
