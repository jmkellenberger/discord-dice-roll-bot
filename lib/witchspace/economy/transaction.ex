defmodule Witchspace.Economy.Transaction do
  use Ecto.Schema
  import Ecto.Changeset

  schema "transactions" do
    field(:amount, :integer)
    field(:date, :integer)
    field(:opening_balance, :integer)
    field(:reason, :string)
    belongs_to(:wallet, Witchspace.Economy.Wallet)

    timestamps()
  end

  @doc false
  def changeset(transaction, attrs) do
    transaction
    |> cast(attrs, [:date, :opening_balance, :amount, :reason])
    |> validate_required([:date, :opening_balance, :amount])
    |> unique_constraint(:wallet_id,
      name: :transactions_date_opening_balance_amount_wallet_id_index
    )
  end
end
