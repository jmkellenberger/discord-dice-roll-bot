defmodule Asema.Interactions.Help do
  @moduledoc """
  Handles /help slash command
  """
  @name "help"
  @description "Lists available slash commands"

  import Nostrum.Struct.Embed
  use Asema.Interaction

  @impl Interaction
  def handle_interaction(_interaction, _options) do
    Asema.Interactions.list_commands()
    |> Enum.reduce(
      %Nostrum.Struct.Embed{},
      &put_field(&2, "/" <> &1.name(), &1.description(), false)
    )
    |> put_title("Available Commands")
    |> response()
    |> private()
  end
end
