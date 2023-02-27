defmodule WitchspaceDiscord.Commands.Transaction do
  @name "transaction"
  @description "Creates a transaction for a wallet."

  use WitchspaceDiscord.Interaction

  @impl Nosedrum.ApplicationCommand
  def options() do
    [
      %{
        type: :string,
        name: "name",
        description: "Name of the wallet to credit or debit from",
        required: true,
        min_length: 2
      },
      %{
        type: :string,
        name: "operation",
        description: "The type of transaction",
        required: true,
        choices: [
          %{name: "Withdrawal", value: "WITHDRAW"},
          %{name: "Deposit", value: "DEPOSIT"}
        ]
      },
      %{
        type: :integer,
        name: "amount",
        description: "The amount for the transaction",
        required: true,
        min_value: 1
      },
      %{
        type: :string,
        name: "comment",
        description: "The reason for the transaction"
      }
    ]
  end

  @impl Nosedrum.ApplicationCommand
  def command(%{guild_id: guild_id} = interaction) do
    with opts <- get_opts(interaction),
         {:ok, wallet} <- Helpers.fetch_wallet(guild_id, opts.name),
         {:ok, _transaction} <- handle_transaction(wallet, opts) do
      [
        content:
          "Transaction successful. Your current balance is **#{Witchspace.Economy.current_balance(wallet)}**.",
        ephemeral?: false
      ]
    else
      {:error, %Ecto.Changeset{} = changeset} ->
        [
          content: Helpers.format_changeset_errors(changeset)
          ephemeral?: true
        ]


      {:error, err} ->
        [
          content: err
          ephemeral?: true
        ]
    end
  end

  defp handle_transaction(wallet, %{operation: "WITHDRAW"} = opts) do
    Witchspace.Economy.create_withdrawal(wallet, opts.amount, opts.reason)
  end

  defp handle_transaction(wallet, %{operation: "DEPOSIT"} = opts) do
    Witchspace.Economy.create_deposit(wallet, opts.amount, opts.reason)
  end

  defp handle_transaction(_wallet, opts) do
    {:error, "**Error**: Operation must be WITHDRAW or DEPOSIT, got: #{opts.operation}"}
  end

  defp get_opts(interaction) do
    %{
      name: Helpers.fetch_opt(interaction, "name", nil) |> String.upcase(),
      operation: Helpers.fetch_opt(interaction, "operation", nil),
      amount: Helpers.fetch_opt(interaction, "amount", nil),
      reason: Helpers.fetch_opt(interaction, "reason", "WITHDRAWAL")
    }
  end
end
