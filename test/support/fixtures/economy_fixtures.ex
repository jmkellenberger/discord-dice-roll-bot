defmodule Witchspace.EconomyFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Witchspace.Economy` context.
  """

  @doc """
  Generate a wallet.
  """
  def wallet_fixture(campaign, attrs \\ %{}) do
    attrs =
      Enum.into(attrs, %{
        name: "some name"
      })

    {:ok, wallet} = Witchspace.Economy.create_wallet(campaign, attrs)

    wallet
  end

  @doc """
  Generate a transaction.
  """
  def transaction_fixture(wallet, attrs \\ %{}) do
    attrs =
      Enum.into(attrs, %{
        amount: 42,
        date: 42,
        opening_balance: 42,
        reason: "some reason"
      })

    {:ok, transaction} = Witchspace.Economy.create_transaction(wallet, attrs)

    transaction
  end
end
