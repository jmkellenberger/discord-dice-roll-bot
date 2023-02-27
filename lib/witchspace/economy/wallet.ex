defmodule Witchspace.Economy.Wallet do
  use Ecto.Schema
  import Ecto.Changeset

  schema "wallets" do
    field(:name, :string)
    belongs_to(:campaign, Witchspace.Campaigns.Campaign)
    has_many(:transactions, Witchspace.Economy.Transaction)

    timestamps()
  end

  @doc false
  def changeset(wallet, attrs) do
    wallet
    |> cast(attrs, [:name])
    |> validate_required([:name])
    |> validate_length(:name, min: 3)
    |> unique_constraint(:name, name: :wallets_name_campaign_id_index)
  end
end
