defmodule WitchspaceDiscord.SlashCommand do
  @callback name() :: String.t()
  @callback register(guild_id :: integer()) :: :ok

  defmacro __using__(_) do
    quote do
      alias Nostrum.Struct.Interaction

      def fetch_opt(%Interaction{data: %{options: nil}}, _opt, default),
        do: default

      def fetch_opt(
            %Interaction{data: %{options: opts}},
            opt,
            default
          ) do
        opts
        |> Enum.filter(&(&1.name == opt))
        |> List.first(%{})
        |> Map.get(:value, default)
      end

      @behaviour WitchspaceDiscord.SlashCommand
      def register(guild_id) do
        case Nosedrum.Interactor.Dispatcher.add_command(
               name(),
               __MODULE__,
               guild_id
             ) do
          {:ok, _} -> IO.puts("Registered #{name()} command.")
          e -> IO.inspect(e, label: "An error occurred registering the #{name()} command")
        end
      end

      defoverridable register: 1
    end
  end
end
