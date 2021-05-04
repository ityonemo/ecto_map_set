defmodule EctoMapSetTest.Repo.Migrations.CreateUntypedTable do
  use Ecto.Migration

  def change do
    create table(:untyped) do
      add(:drop_unsafe, {:array, :binary})
      add(:unsafe, {:array, :binary})
      add(:error_unsafe, {:array, :binary})
      add(:non_executable, {:array, :binary})
    end
  end
end
