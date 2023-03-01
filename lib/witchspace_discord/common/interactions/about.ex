defmodule WitchspaceDiscord.Common.Interactions.About do
  @moduledoc """
  Handles /about slash command
  """

  import Nostrum.Struct.Embed
  use WitchspaceDiscord.Interaction

  @impl InteractionBehaviour
  def get_command do
    command("about")
    |> with_desc("Information about the bot")
  end

  @impl InteractionBehaviour
  def handle_interaction(_interaction, _options) do
    embed =
      %Nostrum.Struct.Embed{}
      |> put_title("Witchspace Information")
      |> put_field("Version", Application.spec(:witchspace, :vsn) |> to_string(), true)
      |> put_field("Uptime", uptime(), true)
      |> put_field("Processes", "#{length(:erlang.processes())}", true)
      |> put_field("Memory Usage", "#{div(:erlang.memory(:total), 1_000_000)} MB", true)

    respond(embed)
    |> private()
  end

  defp uptime do
    {time, _} = :erlang.statistics(:wall_clock)

    sec = div(time, 1000)
    {min, sec} = {div(sec, 60), rem(sec, 60)}
    {hours, min} = {div(min, 60), rem(min, 60)}
    {days, hours} = {div(hours, 24), rem(hours, 24)}

    Stream.zip([sec, min, hours, days], ["s", "m", "h", "d"])
    |> Enum.reduce("", fn
      {0, _glyph}, acc -> acc
      {t, glyph}, acc -> " #{t}" <> glyph <> acc
    end)
  end
end
