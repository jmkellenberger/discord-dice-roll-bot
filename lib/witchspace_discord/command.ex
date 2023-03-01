defmodule WitchspaceDiscord.Command do
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

  defp new(name), do: with_name(%{}, name)

  defp clean_name(name) do
    name
    |> String.downcase()
    |> String.trim()
  end

  def with_name(cmd, name), do: Map.put(cmd, :name, name)
  def with_desc(cmd, desc), do: Map.put(cmd, :description, desc)

  def command(name) do
    name
    |> clean_name()
    |> new()
  end

  def with_option(%{options: opts} = cmd, option), do: %{cmd | options: opts ++ [option]}
  def with_option(cmd, option), do: Map.put(cmd, :options, [option])

  def with_options(cmd, opts), do: Enum.reduce(opts, cmd, &with_option(&2, &1))

  def option(name, type) do
    name
    |> clean_name()
    |> new()
    |> with_type(type)
  end

  def with_type(opt, type), do: Map.put(opt, :type, @option_types[type])

  def with_choice(%{choices: choices} = opt, name, value),
    do: %{opt | choices: choices ++ [choice(name, value)]}

  def with_choice(opt, name, value),
    do: Map.put(opt, :choices, [choice(name, value)])

  def with_choice(opt, name), do: with_choice(opt, name, String.downcase(name))

  def required(opt), do: Map.put(opt, :required, true)

  def choice(name, value) do
    name
    |> new()
    |> with_value(value)
  end

  def with_value(choice, value), do: Map.put(choice, :value, value)
end
