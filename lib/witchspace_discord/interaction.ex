defmodule WitchspaceDiscord.Interaction do
  defmacro __using__(_) do
    quote location: :keep do
      alias WitchspaceDiscord.Helpers

      @behaviour Nosedrum.ApplicationCommand

      @impl Nosedrum.ApplicationCommand
      def type, do: :slash

      @impl Nosedrum.ApplicationCommand
      def description, do: @description

      def name, do: @name

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

      defoverridable register: 1, description: 0, name: 0, type: 0
    end
  end
end
