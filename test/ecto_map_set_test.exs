defmodule EctoMapSetTest do
  use ExUnit.Case
  alias EctoMapSetTest.Scalar
  alias EctoMapSetTest.Composite
  alias EctoMapSetTest.Repo

  def checkout_ecto_sandbox(tags) do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(EctoMapSetTest.Repo)
  end

  setup :checkout_ecto_sandbox

  describe "for a scalar data" do
    test "you can save uuids in a MapSet" do
      uuid = UUID.uuid4()
      uuid_set = MapSet.new([uuid])

      assert {:ok, %{id: id, uuid: ^uuid_set}} = %{uuid: uuid_set}
      |> Scalar.changeset()
      |> Repo.insert

      assert %{uuid: ^uuid_set} = Repo.get(Scalar, id)
    end

    test "you can save strings in a MapSet" do
      string = "foobar"
      string_set = MapSet.new([string])

      assert {:ok, %{id: id, string: ^string_set}} = %{string: string_set}
      |> Scalar.changeset()
      |> Repo.insert

      assert %{string: ^string_set} = Repo.get(Scalar, id)
    end

    test "you can save integers in a MapSet" do
      integer = 47
      integer_set = MapSet.new([integer])

      assert {:ok, %{id: id, integer: ^integer_set}} = %{integer: integer_set}
      |> Scalar.changeset()
      |> Repo.insert

      assert %{integer: ^integer_set} = Repo.get(Scalar, id)
    end

    test "you can save it as an array instead" do
      integer = 47
      integer_set = MapSet.new([integer])

      assert {:ok, %{id: id, integer: ^integer_set}} = %{integer: [47, 47]}
      |> Scalar.changeset()
      |> Repo.insert

      assert %{integer: ^integer_set} = Repo.get(Scalar, id)
    end

    test "you can save it as a stream" do
      stream = Stream.take(1..10, 10)
      stream_set = MapSet.new(stream)

      assert {:ok, %{id: id, integer: ^stream_set}} = %{integer: stream}
      |> Scalar.changeset()
      |> Repo.insert

      assert %{integer: ^stream_set} = Repo.get(Scalar, id)
    end
  end

  describe "the basic changeset" do
    test "validates invalid data" do
      assert %{
        errors: [integer: {"is invalid", _}],
        valid?: false} = Scalar.changeset(%{integer: ["foobar"]})
    end
  end

  describe "for composite data" do
    test "you can save vectors in a MapSet" do
      vector1 = [47.0, 47.1, 47.2]
      vector2 = [42.0, 42.1, 47.2]
      # note these must have the same length.

      vector_set = MapSet.new([vector1, vector2])

      assert {:ok, %{id: id, vector: ^vector_set}} = %{vector: vector_set}
      |> Composite.changeset()
      |> Repo.insert

      assert %{vector: ^vector_set} = Repo.get(Composite, id)
    end
  end
end
