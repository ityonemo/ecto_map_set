defmodule EctoMapSetTest.Untyped do
  use Ecto.Schema

  alias EctoMapSet, as: MapSet

  schema "untyped" do
    field(:drop_unsafe, MapSet, of: :term) # same as safety: :drop
    field(:unsafe, MapSet, of: :term, safety: :unsafe)
    field(:error_unsafe, MapSet, of: :term, safety: :errors)
    # Requires Plug.Crypto library.
    field(:non_executable, MapSet, of: :term, non_executable: :true)
  end

  def changeset(data) do
    Ecto.Changeset.cast(%__MODULE__{}, data, [:drop_unsafe, :unsafe, :error_unsafe, :non_executable])
  end
end
