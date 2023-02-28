defmodule WitchspaceDiscord.Interaction do
  @moduledoc """
  Common aliases and helper functions used by all interactions
  """
  defmacro __using__(_) do
    quote location: :keep do
      import WitchspaceDiscord.Response
      import WitchspaceDiscord.Command
      alias Nostrum.Struct.{ApplicationCommand, Interaction}

      alias WitchspaceDiscord.{InteractionBehaviour}

      @behaviour InteractionBehaviour

      defp get_option(options, name, default \\ nil) do
        case Enum.find(options, fn opt -> opt.name == name end) do
          nil ->
            nil

          option ->
            {option.value, option.focused}
        end
      end
    end
  end
end
