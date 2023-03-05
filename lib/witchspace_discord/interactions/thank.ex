defmodule WitchspaceDiscord.Interactions.Thank do
  @moduledoc """
  Thanks ASEMA
  """
  @name "thank"
  @description "Thank ASEMA"

  use WitchspaceDiscord.Interaction

  @impl Interaction
  def handle_interaction(interaction, _options),
    do: response("You're welcome, <@#{get_user_id(interaction)}>")
end
