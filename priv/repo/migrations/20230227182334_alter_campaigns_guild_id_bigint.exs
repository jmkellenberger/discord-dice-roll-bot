defmodule Witchspace.Repo.Migrations.AlterCampaignsGuildIdBigint do
  use Ecto.Migration

  def change do
    alter table(:campaigns) do
      modify :guild_id, :bigint
    end
  end
end
