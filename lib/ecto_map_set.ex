defmodule EctoMapSet do
  @moduledoc """
  Typed MapSet support for Ecto.

  The MapSets are backed by arrays in postgres.  Currently untested in other
  database engines.  A different package that backs the MapSets, untyped, with
  a map might be forthcoming.

  ### Migration Example:

  ```elixir
  def change do
    create table(:my_sets) do
      add(:favorite_floats, {:array, :float})
    end
  end
  ```

  ### Schema Example:

  ```elixir
  def MySet do
    use Ecto.Schema
    schema "my_sets" do
      field :favorite_floats, EctoMapSet, of: :float
    end
  end
  ```

  Then when you retrieve your row, the data will be marshalled into
  a MapSet:

  ```elixir
  iex> Repo.get(MySet, id)
  %MySet{favorite_floats: %MapSet<[47.0, 88.8]>}}
  ```

  If you use an ecto changeset to marshal your data in, your mapset
  column may be any sort of enumerable.  In most cases that will be
  a `MapSet`, a `List`, or a `Stream`.

  NB: for PostgreSQL, if you are making a mapset of arrays, they must
  all have the same length.  This is a limitation of PostgreSQL.  This happens
  for a schema that looks like this:

  ```
  schema "my_vectors" do
    field :vectors, EctoMapSet, of: {:array, :float}
  end
  ```
  """

  use Ecto.ParameterizedType

  @impl true
  def type(opts), do: {:array, opts[:of]}

  @impl true
  def init(opts) do
    Enum.into(opts, %{})
  end

  @impl true
  def cast(data, params) do
    result = MapSet.new(data, fn datum ->
      case Ecto.Type.cast(params.of, datum) do
        {:ok, cast} -> cast
        error -> throw error
      end
    end)
    {:ok, result}
  catch
    error -> error
  end

  @impl true
  def load(nil, _, _), do: {:ok, nil}
  def load(data, loader, params) do
    result = MapSet.new(data, fn datum ->
      case loader.(params.of, datum) do
        {:ok, encoded} -> encoded
        :error -> throw :error
      end
    end)

    {:ok, result}

  catch
    :error -> :error
  end

  @impl true
  def dump(nil, _, _), do: {:ok, nil}
  def dump(data, dumper, params) do
    result = Enum.map(data, fn datum ->
      case dumper.(params.of, datum) do
        {:ok, encoded} -> encoded
        :error -> throw :error
      end
    end)

    {:ok, result}
  catch
    :error -> :error
  end

  @impl true
  def equal?(a, b, _params) do
    a == b
  end
end
