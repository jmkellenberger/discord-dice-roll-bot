defmodule Witchspace.EconomyTest do
  use Witchspace.DataCase

  alias Witchspace.Economy

  describe "wallets" do
    alias Witchspace.Economy.Wallet

    import Witchspace.EconomyFixtures
    import Witchspace.CampaignsFixtures

    @invalid_attrs %{name: nil}

    setup do
      campaign = campaign_fixture()
      {:ok, campaign: campaign}
    end

    test "list_wallets/0 returns all wallets", %{campaign: campaign} do
      wallet = wallet_fixture(campaign)
      assert Economy.list_wallets(campaign) == [wallet]
    end

    test "get_wallet!/1 returns the wallet with given id", %{campaign: campaign} do
      wallet = wallet_fixture(campaign)
      assert Economy.get_wallet!(campaign, wallet.id) == wallet
    end

    test "create_wallet/1 with valid data creates a wallet", %{campaign: campaign} do
      valid_attrs = %{name: "some name"}

      assert {:ok, %Wallet{} = wallet} = Economy.create_wallet(campaign, valid_attrs)
      assert wallet.name == "some name"
    end

    test "create_wallet/1 with invalid data returns error changeset", %{campaign: campaign} do
      assert {:error, %Ecto.Changeset{}} = Economy.create_wallet(campaign, @invalid_attrs)
    end

    test "update_wallet/2 with valid data updates the wallet", %{campaign: campaign} do
      wallet = wallet_fixture(campaign)
      update_attrs = %{name: "some updated name"}

      assert {:ok, %Wallet{} = wallet} = Economy.update_wallet(wallet, update_attrs)
      assert wallet.name == "some updated name"
    end

    test "update_wallet/2 with invalid data returns error changeset", %{campaign: campaign} do
      wallet = wallet_fixture(campaign)
      assert {:error, %Ecto.Changeset{}} = Economy.update_wallet(wallet, @invalid_attrs)
      assert wallet == Economy.get_wallet!(campaign, wallet.id)
    end

    test "delete_wallet/1 deletes the wallet", %{campaign: campaign} do
      wallet = wallet_fixture(campaign)
      assert {:ok, %Wallet{}} = Economy.delete_wallet(wallet)
      assert_raise Ecto.NoResultsError, fn -> Economy.get_wallet!(campaign, wallet.id) end
    end

    test "change_wallet/1 returns a wallet changeset", %{campaign: campaign} do
      wallet = wallet_fixture(campaign)
      assert %Ecto.Changeset{} = Economy.change_wallet(wallet)
    end
  end

  describe "transactions" do
    alias Witchspace.Economy.Transaction

    import Witchspace.EconomyFixtures
    import Witchspace.CampaignsFixtures

    @invalid_attrs %{amount: nil, date: nil, opening_balance: nil, reason: nil}

    setup do
      wallet =
        campaign_fixture()
        |> wallet_fixture()

      {:ok, wallet: wallet}
    end

    test "list_transactions/0 returns all transactions", %{wallet: wallet} do
      transaction = transaction_fixture(wallet)
      assert Economy.list_transactions(wallet) == [transaction]
    end

    test "get_transaction!/1 returns the transaction with given id", %{wallet: wallet} do
      transaction = transaction_fixture(wallet)
      assert Economy.get_transaction!(wallet, transaction.id) == transaction
    end

    test "create_transaction/1 with valid data creates a transaction", %{wallet: wallet} do
      valid_attrs = %{amount: 42, date: 42, opening_balance: 42, reason: "some reason"}

      assert {:ok, %Transaction{} = transaction} = Economy.create_transaction(wallet, valid_attrs)
      assert transaction.amount == 42
      assert transaction.date == 42
      assert transaction.opening_balance == 42
      assert transaction.reason == "some reason"
    end

    test "create_transaction/1 with invalid data returns error changeset", %{wallet: wallet} do
      assert {:error, %Ecto.Changeset{}} = Economy.create_transaction(wallet, @invalid_attrs)
    end

    test "update_transaction/2 with valid data updates the transaction", %{wallet: wallet} do
      transaction = transaction_fixture(wallet)

      update_attrs = %{
        amount: 43,
        date: 43,
        opening_balance: 43,
        reason: "some updated reason"
      }

      assert {:ok, %Transaction{} = transaction} =
               Economy.update_transaction(transaction, update_attrs)

      assert transaction.amount == 43
      assert transaction.date == 43
      assert transaction.opening_balance == 43
      assert transaction.reason == "some updated reason"
    end

    test "update_transaction/2 with invalid data returns error changeset", %{wallet: wallet} do
      transaction = transaction_fixture(wallet)
      assert {:error, %Ecto.Changeset{}} = Economy.update_transaction(transaction, @invalid_attrs)
      assert transaction == Economy.get_transaction!(wallet, transaction.id)
    end

    test "delete_transaction/1 deletes the transaction", %{wallet: wallet} do
      transaction = transaction_fixture(wallet)
      assert {:ok, %Transaction{}} = Economy.delete_transaction(transaction)
      assert_raise Ecto.NoResultsError, fn -> Economy.get_transaction!(wallet, transaction.id) end
    end

    test "change_transaction/1 returns a transaction changeset", %{wallet: wallet} do
      transaction = transaction_fixture(wallet)
      assert %Ecto.Changeset{} = Economy.change_transaction(transaction)
    end
  end
end
