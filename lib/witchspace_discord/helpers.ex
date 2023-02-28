defmodule WitchspaceDiscord.Helpers do
  @moduledoc """
  Helpers for handling the interaction and options
  """

  alias Nostrum.Struct.ApplicationCommandInteractionData

  alias WitchspaceDiscord.InteractionBehaviour


  @spec parse_interaction_data(ApplicationCommandInteractionData.t()) ::
          InteractionBehaviour.interaction_input()
  def parse_interaction_data(interaction_data) when is_binary(interaction_data.custom_id) do
    [command_string, options_string] = String.split(interaction_data.custom_id, "|")

    options =
      String.split(options_string, ":")
      |> Enum.chunk_every(2)
      |> Enum.reduce([], fn [name, value], acc ->
        acc ++ [%{name: name, value: value, focused: false}]
      end)

    {command_string, options}
  end

  def parse_interaction_data(interaction_data) do
    options = parse_list_of_options(interaction_data.options)

    {interaction_data.name, options}
  end

  defp parse_list_of_options(options) when is_nil(options), do: []

  defp parse_list_of_options(options) do
    Enum.flat_map(options, fn option ->
      case option.type do
        1 -> parse_sub_command(option)
        _ -> [parse_data_option(option)]
      end
    end)
  end

  defp parse_sub_command(option) do
    [%{name: option.name, value: "", focused: false}] ++ parse_list_of_options(option.options)
  end

  defp parse_data_option(option) do
    %{
      name: option.name,
      value: option.value,
      focused: if(is_nil(Map.get(option, :focused)), do: false, else: option.focused)
    }
  end

  @spec get_term(InteractionBehaviour.interaction_options()) :: {String.t(), boolean()}
  def get_term(options) do
    get_option(options, "term")
  end

  @spec get_option!(InteractionBehaviour.interaction_options(), String.t()) ::
          {String.t(), boolean()}
  def get_option!(options, name) do
    case get_option(options, name) do
      nil ->
        raise("Invalid option received")

      option ->
        option
    end
  end

  @spec get_option(InteractionBehaviour.interaction_options(), String.t()) ::
          nil | {String.t(), boolean()}
  def get_option(options, name) do
    case Enum.find(options, fn opt -> opt.name == name end) do
      nil ->
        nil

      option ->
        {option.value, option.focused}
    end
  end

  def format_changeset_errors(%Ecto.Changeset{errors: errors}) do
    Enum.map(errors, fn {k, {msg, _}} -> "**#{Phoenix.Naming.humanize(k)}**: #{msg}" end)
    |> Enum.join("\n")
  end
end
