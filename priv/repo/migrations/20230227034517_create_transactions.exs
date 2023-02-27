defmodule Witchspace.Repo.Migrations.CreateTransactions do
  use Ecto.Migration

  def change do
    create table(:transactions) do
      add(:date, :integer, null: false)
      add(:opening_balance, :integer, null: false)
      add(:amount, :integer, null: false)
      add(:reason, :string)
      add(:wallet_id, references(:wallets, on_delete: :delete_all))

      timestamps()
    end

    create(index(:transactions, [:wallet_id]))
    create(unique_index(:transactions, [:date, :opening_balance, :amount, :wallet_id]))
  end
end
