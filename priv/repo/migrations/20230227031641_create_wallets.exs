defmodule Witchspace.Repo.Migrations.CreateWallets do
  use Ecto.Migration

  def change do
    create table(:wallets) do
      add(:name, :string, null: false)
      add(:campaign_id, references(:campaigns, on_delete: :delete_all))

      timestamps()
    end

    create(index(:wallets, [:campaign_id]))
    create(unique_index(:wallets, [:name, :campaign_id]))
  end
end
