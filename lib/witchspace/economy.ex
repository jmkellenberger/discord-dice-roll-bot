defmodule Witchspace.Economy do
  @moduledoc """
  The Economy context.
  """

  import Ecto.Query, warn: false
  alias Witchspace.Repo
  alias Witchspace.Economy.Transaction
  alias Witchspace.Economy.Wallet

  @doc """
  Returns the list of wallets for a given campaign.

  ## Examples
      iex> campaign = %Witchspace.Campaigns.Campaign{}
      iex> list_wallets(campaign)
      [%Wallet{}, ...]

  """
  def list_wallets(campaign) do
    from(v in Wallet, where: [campaign_id: ^campaign.id], order_by: [asc: :id])
    |> Repo.all()
  end

  @doc """
  Gets a single wallet.

  Raises `Ecto.NoResultsError` if the Wallet does not exist.

  ## Examples
      campaign = %Witchspace.Campaigns.Campaign{}

      iex> get_wallet!(campaign, 123)
      %Wallet{}

      iex> get_wallet!(campaign, 456)
      ** (Ecto.NoResultsError)

  """
  def get_wallet!(campaign, id),
    do: Repo.get_by!(Wallet, campaign_id: campaign.id, id: id)

  @doc """
  Creates a wallet.

  ## Examples
      campaign = %Witchspace.Campaigns.Campaign{}
      iex> create_wallet(campaign, %{field: value})
      {:ok, %Wallet{}}

      iex> create_wallet(campaign, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_wallet(campaign, attrs \\ %{}) do
    campaign
    |> Ecto.build_assoc(:wallets)
    |> Wallet.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a wallet.

  ## Examples

      iex> update_wallet(wallet, %{field: new_value})
      {:ok, %Wallet{}}

      iex> update_wallet(wallet, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_wallet(%Wallet{} = wallet, attrs) do
    wallet
    |> Wallet.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a wallet.

  ## Examples

      iex> delete_wallet(wallet)
      {:ok, %Wallet{}}

      iex> delete_wallet(wallet)
      {:error, %Ecto.Changeset{}}

  """
  def delete_wallet(%Wallet{} = wallet) do
    Repo.delete(wallet)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking wallet changes.

  ## Examples

      iex> change_wallet(wallet)
      %Ecto.Changeset{data: %Wallet{}}

  """
  def change_wallet(%Wallet{} = wallet, attrs \\ %{}) do
    Wallet.changeset(wallet, attrs)
  end

  @doc """
  Returns the list of transactions.

  ## Examples

      iex> list_transactions()
      [%Transaction{}, ...]

  """
  def list_transactions(wallet) do
    from(v in Transaction, where: [wallet_id: ^wallet.id], order_by: [asc: :id])
    |> Repo.all()
  end

  def get_last_transaction(wallet) do
    from(v in Transaction, where: [wallet_id: ^wallet.id], order_by: [desc: :id])
    |> Repo.all()
    |> List.first(nil)
  end

  @doc """
  Gets a single transaction.

  Raises `Ecto.NoResultsError` if the Transaction does not exist.

  ## Examples

      iex> get_transaction!(123)
      %Transaction{}

      iex> get_transaction!(456)
      ** (Ecto.NoResultsError)

  """
  def get_transaction!(wallet, id), do: Repo.get_by!(Transaction, wallet_id: wallet.id, id: id)

  @doc """
  Creates a transaction.

  ## Examples

      iex> create_transaction(%{field: value})
      {:ok, %Transaction{}}

      iex> create_transaction(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_transaction(wallet, attrs \\ %{}) do
    wallet
    |> Ecto.build_assoc(:transactions)
    |> Transaction.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a transaction.

  ## Examples

      iex> update_transaction(transaction, %{field: new_value})
      {:ok, %Transaction{}}

      iex> update_transaction(transaction, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_transaction(%Transaction{} = transaction, attrs) do
    transaction
    |> Transaction.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a transaction.

  ## Examples

      iex> delete_transaction(transaction)
      {:ok, %Transaction{}}

      iex> delete_transaction(transaction)
      {:error, %Ecto.Changeset{}}

  """
  def delete_transaction(%Transaction{} = transaction) do
    Repo.delete(transaction)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking transaction changes.

  ## Examples

      iex> change_transaction(transaction)
      %Ecto.Changeset{data: %Transaction{}}

  """
  def change_transaction(%Transaction{} = transaction, attrs \\ %{}) do
    Transaction.changeset(transaction, attrs)
  end

  def current_balance(wallet) do
    wallet
    |> get_last_transaction()
    |> calculate_balance()
  end

  defp calculate_balance(%{opening_balance: bal, amount: amount}), do: bal + amount
  defp calculate_balance(nil), do: 0

  def create_withdrawal(wallet, amount, reason \\ "WITHDRAWAL") when amount > 0 do
    wallet = Repo.preload(wallet, [:transactions, :campaign])

    attrs = %{
      amount: -amount,
      date: wallet.campaign.date,
      opening_balance: current_balance(wallet),
      reason: reason
    }

    create_transaction(wallet, attrs)
  end

  def create_deposit(wallet, amount, reason \\ "DEPOSIT") when amount > 0 do
    wallet = Repo.preload(wallet, [:transactions, :campaign])

    attrs = %{
      amount: amount,
      date: wallet.campaign.date,
      opening_balance: current_balance(wallet),
      reason: reason
    }

    create_transaction(wallet, attrs)
  end
end
