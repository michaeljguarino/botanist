defmodule Botanist.Repo.Migrations.CreateTestSeedTable do
  use Ecto.Migration

  def change do
    create table(:seed) do
      add(:name, :text)
      add(:inserted_at, :naive_datetime)
    end
  end
end
