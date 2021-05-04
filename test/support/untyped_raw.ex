defmodule EctoMapSetTest.UntypedRaw do
  # gives raw access to the untyped data so that we can inject malicious
  # payloads in test.

  use Ecto.Schema

  schema "untyped" do
    field(:drop_unsafe, {:array, :binary})
    field(:unsafe, {:array, :binary})
    field(:error_unsafe, {:array, :binary})
    # Requires Plug.Crypto library.
    field(:non_executable, {:array, :binary})
  end

  def changeset(data) do
    Ecto.Changeset.cast(%__MODULE__{}, data, [:drop_unsafe, :unsafe, :error_unsafe, :non_executable])
  end
end
