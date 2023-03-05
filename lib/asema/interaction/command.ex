defmodule Asema.Interaction.Command do
  @moduledoc """
  Helpers for constructing slash commands
  """

  @option_types %{
    subcommand: 1,
    group: 2,
    str: 3,
    # Any int between -2^53 and 2^53
    int: 4,
    bool: 5,
    user: 6,
    # Includes all channel types + categories
    channel: 7,
    # Includes users and roles
    role: 8,
    mentionable: 9,
    # Any double between -2^53 and 2^53
    float: 10,
    attachment: 11
  }

  def command(name, desc, options \\ []) do
    %{}
    |> put_name(name)
    |> put_desc(desc)
    |> put_option(options)
  end

  def option(name, desc, type, choices \\ []) do
    %{}
    |> put_name(name)
    |> put_desc(desc)
    |> put_type(type)
    |> put_choice(choices)
  end

  def required_option(name, desc, type, choices \\ []) do
    required(option(name, desc, type, choices))
  end

  def choice(name) do
    choice(name, clean(name))
  end

  def choice(name, value) do
    %{}
    |> put_name(name)
    |> Map.put(:value, value)
  end

  defp required(opt) do
    Map.put(opt, :required, true)
  end

  defp clean(name) do
    name
    |> String.downcase()
    |> String.trim()
  end

  defp put_name(cmd, name) do
    Map.put(cmd, :name, clean(name))
  end

  defp put_desc(cmd, desc) do
    Map.put(cmd, :description, desc)
  end

  defp put_option(cmd, []), do: cmd

  defp put_option(cmd, option) when is_list(option) do
    Enum.reduce(option, cmd, &put_option(&2, &1))
  end

  defp put_option(%{options: opts} = cmd, option) do
    Map.put(cmd, :options, opts ++ [option])
  end

  defp put_option(cmd, option) do
    Map.put(cmd, :options, [option])
  end

  defp put_type(opt, type) do
    Map.put(opt, :type, @option_types[type])
  end

  defp put_choice(option, []), do: option

  defp put_choice(option, choices) when is_list(choices) do
    Enum.reduce(choices, option, &put_choice(&2, &1))
  end

  defp put_choice(option, choice) do
    c = choice(choice)
    Map.update(option, :choices, [c], &(&1 ++ [c]))
  end
end
