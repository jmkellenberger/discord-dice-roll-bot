defmodule Asema.Interaction do
  @moduledoc """
  Behaviour for handling Discord interactions, through slash commands or components
  """

  @type interaction_options :: list(%{name: String.t(), value: any(), focused: bool()})
  @type interaction_input :: {String.t(), interaction_options()}

  @doc """
  Returns the object defining the slash command to be created.
  If the interaction only responds to components, returns nil
  """
  @callback get_command() :: Nostrum.Struct.ApplicationCommand.application_command_map() | nil

  @doc """
  Returns the name of the command
  """
  @callback name() :: String.t()

  @doc """
  Returns the command description
  """
  @callback description() :: String.t()

  @doc """
  Returns the command's options
  """
  @callback options() :: list() | map()

  @doc """
  Parses the current interaction, returning the interaction response to be sent to Discord
  """
  @callback handle_interaction(Nostrum.Struct.Interaction.t(), interaction_options()) :: map()

  defmacro __using__(_) do
    quote location: :keep do
      import Asema.Interaction.{Command, Response}

      alias Asema.Interaction

      @behaviour Interaction

      @impl Interaction
      def name, do: @name

      @impl Interaction
      def description, do: @description

      @impl Interaction
      def options, do: []

      @impl Interaction
      def get_command do
        command(name(), description(), options())
      end

      defoverridable options: 0, get_command: 0
    end
  end
end
