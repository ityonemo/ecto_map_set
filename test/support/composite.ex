defmodule EctoMapSetTest.Composite do
  use Ecto.Schema

  alias EctoMapSet, as: MapSet

  schema "composite" do
    field(:vector, MapSet, of: {:array, :float})
  end

  def changeset(data) do
    Ecto.Changeset.cast(%__MODULE__{}, data, [:vector])
  end
end
