defmodule EctoMapSetTest.Repo.Migrations.CreateCompositeTable do
  use Ecto.Migration

  def change do
    create table(:composite) do
      add(:vector, {:array, {:array, :float}})
    end
  end
end
