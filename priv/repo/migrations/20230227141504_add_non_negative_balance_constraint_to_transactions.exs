defmodule Witchspace.Repo.Migrations.AddNonNegativeBalanceConstraintToTransactions do
  use Ecto.Migration

  def change do
    create(
      constraint(:transactions, :balance_cannot_be_negative,
        check: "amount + opening_balance >= 0"
      )
    )
  end
end
