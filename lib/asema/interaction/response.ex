defmodule Asema.Interaction.Response do
  @moduledoc """
  Helper module for building interaction responses
  """
  @type t() :: %{
          type: interaction_callback_value(),
          data: map()
        }

  @type interaction_callback_value() :: 1 | 4..9
  @type interaction_callback_type() ::
          :pong
          | :message
          | :deferred_message
          | :deferred_update
          | :update
          | :autocomplete
          | :modal

  @callback_types %{
    pong: 1,
    message: 4,
    deferred_message: 5,
    deferred_update: 6,
    update: 7,
    autocomplete: 8,
    modal: 9
  }

  @doc """
  Fetches an option value from an interaction by name
  """
  def get_option(options, name) do
    case Enum.find(options, fn opt -> opt.name == name end) do
      nil ->
        nil

      option ->
        {option.value, option.focused}
    end
  end

  @spec get_user_id(Nostrum.Struct.Interaction.t()) :: integer | nil
  def get_user_id(%{member: %{user: %{id: id}}}), do: id
  def get_user_id(_interaction), do: nil

  @doc """
  Builds empty response of given type
  """
  @spec response(
          msg :: Nostrum.Struct.Embed.t() | String.t(),
          type :: interaction_callback_type()
        ) :: t()
  def response(msg, type \\ :message)

  def response(%Nostrum.Struct.Embed{} = msg, type) do
    %{}
    |> Map.put(:type, @callback_types[type])
    |> Map.put(:data, %{})
    |> put_embeds(msg)
  end

  def response(msg, type) when is_binary(msg) do
    %{}
    |> Map.put(:type, @callback_types[type])
    |> Map.put(:data, Map.new())
    |> put_content(msg)
  end

  @doc """
  Puts message into response body.
  """
  @spec put_content(resp :: t(), content :: String.t()) :: t()
  def put_content(resp, content) do
    %{resp | data: Map.put(resp.data, :content, content)}
  end

  @doc """
  Puts embeds into response body.
  """
  @spec put_embeds(resp :: t(), embeds :: Nostrum.Struct.Embed.t()) :: t()
  def put_embeds(resp, embeds) do
    %{resp | data: Map.put(resp.data, :embeds, [embeds])}
  end

  @doc """
  Sets Ephemeral bit flag in response.
  """
  @spec private(resp :: t()) :: t()
  def private(resp) do
    %{resp | data: Map.put(resp.data, :flags, 64)}
  end
end
