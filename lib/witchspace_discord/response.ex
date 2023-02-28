defmodule WitchspaceDiscord.Response do
  @moduledoc """
  Helper module for building interaction responses
  """
  @type t() :: %{
          type: interaction_callback_value(),
          data: Map.t()
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
  Builds empty response of given type
  """
  @spec respond(type :: interaction_callback_type()) :: t()
  def respond(type \\ :message) do
    %{}
    |> Map.put(:type, @callback_types[type])
    |> Map.put(:data, Map.new())
  end

  @doc """
  Puts message into response body.
  """
  @spec with_content(resp :: t(), content :: String.t()) :: t()
  def with_content(resp, content) do
    %{resp | data: Map.put(resp.data, :content, content)}
  end

  @doc """
  Puts embeds into response body.
  """
  @spec with_embeds(resp :: t(), embeds :: Nostrum.Struct.Embed) :: t()
  def with_embeds(resp, embeds) do
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
