defmodule WitchspaceDiscord.Commands.NewWallet do
  @name "new_wallet"
  @description "Opens a new wallet for banking."

  use WitchspaceDiscord.Interaction

  @impl Nosedrum.ApplicationCommand
  def options() do
    [
      %{
        type: :string,
        name: "name",
        description: "The wallet name, will be converted to UPCASE.",
        required: true,
        min_length: 2
      }
    ]
  end

  @impl Nosedrum.ApplicationCommand
  def command(%{guild_id: guild_id} = interaction) do
    content =
      with {:ok, campaign} <- Helpers.fetch_campaign(guild_id),
           name <- %{name: Helpers.fetch_opt(interaction, "name", nil) |> String.upcase()},
           {:ok, wallet} <- Witchspace.Economy.create_wallet(campaign, name) do
        "Success! Account: #{wallet.name} initialized. The current balance is **#{Witchspace.Economy.current_balance(wallet)}**."
      else
        {:error, %Ecto.Changeset{} = c} ->
          Helpers.format_changeset_errors(c)

        {:error, err} ->
          err
      end

    [
      content: content,
      ephemeral?: true
    ]
  end
end
