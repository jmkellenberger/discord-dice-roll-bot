defmodule WitchspaceDiscord.Interaction do
  defmacro __using__(_) do
    quote location: :keep do
      import WitchspaceDiscord.Response
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
