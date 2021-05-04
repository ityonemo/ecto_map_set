defmodule EctoMapSetTest do
  use ExUnit.Case
  alias EctoMapSetTest.Scalar
  alias EctoMapSetTest.Composite
  alias EctoMapSetTest.Repo
  alias EctoMapSetTest.Untyped
  alias EctoMapSetTest.UntypedRaw

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

  describe "for untyped data" do
    test "you can save whatever (really) in a MapSet" do
      string = "foo bar"
      integer = 47
      pid = self()
      list = [:a, "b", 44, []]
      map = %{[] => "yup"}

      untyped = MapSet.new([string, integer, pid, list, map])

      assert {:ok, %{id: id, drop_unsafe: ^untyped}} = %{drop_unsafe: untyped}
      |> Untyped.changeset()
      |> Repo.insert

      assert %{drop_unsafe: ^untyped} = Repo.get(Untyped, id)
    end

    # ETF encoding for the atom quuxquuxquux
    @unsafe_atom <<131, 100, 0, 12, 113, 117, 117, 120, 113, 117, 117, 120, 113, 117, 117, 120>>
    test "unsafe data is dropped in the default mode" do
      assert {:ok, %{id: id}} = %{drop_unsafe: [@unsafe_atom, :erlang.term_to_binary("foo")]}
      |> UntypedRaw.changeset()
      |> Repo.insert

      mapset = MapSet.new(["foo"])

      assert %{drop_unsafe: ^mapset} = Repo.get(Untyped, id)
    end

    test "unsafe data errors in the safety: :errors mode" do
      assert {:ok, %{id: id}} = %{error_unsafe: [@unsafe_atom, :erlang.term_to_binary("foo")]}
      |> UntypedRaw.changeset()
      |> Repo.insert

      assert_raise ArgumentError, fn -> Repo.get(Untyped, id) end
    end

    @other_unsafe_atom <<131, 100, 0, 4, 120, 111, 120, 111>>

    test "unsafe data comes through in the safety: :unsafe mode" do
      assert {:ok, %{id: id}} = %{unsafe: [@other_unsafe_atom, :erlang.term_to_binary("foo")]}
      |> UntypedRaw.changeset()
      |> Repo.insert

      assert Untyped
      |> Repo.get(id)
      |> Map.get(:unsafe)
      |> Enum.any?(&(:erlang.term_to_binary(&1) == @other_unsafe_atom))
    end

    test "non-executable maps cannot take a function" do
      refute Untyped.changeset(%{non_executable: [&(&1)]}).valid?
      refute Untyped.changeset(%{non_executable: [[&(&1)]]}).valid? # hiding in a list
      refute Untyped.changeset(%{non_executable: [{&(&1)}]}).valid? # hiding in a tuple
      refute Untyped.changeset(%{non_executable: [%{&(&1) => []}]}).valid? # hiding in a map key
      refute Untyped.changeset(%{non_executable: [%{[] => &(&1)}]}).valid? # hiding in a map value
    end

    test "functions get silently ignored (composes with safety)" do
      fun_bin = :erlang.term_to_binary(&(&1))

      assert {:ok, %{id: id}} = %{non_executable: [fun_bin, :erlang.term_to_binary("foo")]}
      |> UntypedRaw.changeset()
      |> Repo.insert

      map_set = MapSet.new(["foo"])

      assert %{non_executable: ^map_set} = Repo.get(Untyped, id)
    end
  end
end
