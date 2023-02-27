defmodule Witchspace.Repo.Migrations.CreateCampaigns do
  use Ecto.Migration

  def change do
    create table(:campaigns) do
      add(:name, :string)
      add(:date, :integer)
      add(:year_length, :integer)
      add(:guild_id, :integer)

      timestamps()
    end

    create(unique_index(:campaigns, [:guild_id]))
  end
end
