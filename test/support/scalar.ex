defmodule EctoMapSetTest.Scalar do
  use Ecto.Schema

  alias EctoMapSet, as: MapSet

  schema "scalar" do
    field(:uuid, MapSet, of: :binary_id)
    field(:string, MapSet, of: :string)
    field(:integer, MapSet, of: :integer)
  end

  def changeset(data) do
    Ecto.Changeset.cast(%__MODULE__{}, data, [:uuid, :string, :integer])
  end
end
