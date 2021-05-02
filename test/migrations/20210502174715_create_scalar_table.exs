defmodule EctoMapSetTest.Repo.Migrations.CreateScalarTable do
  use Ecto.Migration

  def change do
    create table(:scalar) do
      add(:uuid, {:array, :binary_id})
      add(:string, {:array, :string})
      add(:integer, {:array, :integer})
    end
  end
end
