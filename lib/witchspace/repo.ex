defmodule Witchspace.Repo do
  use Ecto.Repo,
    otp_app: :witchspace,
    adapter: Ecto.Adapters.Postgres
end
