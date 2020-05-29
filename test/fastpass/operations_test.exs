defmodule Fastpass.OperationsTest do
  use Fastpass.DataCase

  alias Fastpass.Operations

  describe "working_times" do
    alias Fastpass.Operations.WorkingTime

    @valid_attrs %{}
    @update_attrs %{}
    @invalid_attrs %{}

    def working_time_fixture(attrs \\ %{}) do
      {:ok, working_time} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Operations.create_working_time()

      working_time
    end

    test "list_working_times/0 returns all working_times" do
      working_time = working_time_fixture()
      assert Operations.list_working_times() == [working_time]
    end

    test "get_working_time!/1 returns the working_time with given id" do
      working_time = working_time_fixture()
      assert Operations.get_working_time!(working_time.id) == working_time
    end

    test "create_working_time/1 with valid data creates a working_time" do
      assert {:ok, %WorkingTime{} = working_time} = Operations.create_working_time(@valid_attrs)
    end

    test "create_working_time/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Operations.create_working_time(@invalid_attrs)
    end

    test "update_working_time/2 with valid data updates the working_time" do
      working_time = working_time_fixture()
      assert {:ok, %WorkingTime{} = working_time} = Operations.update_working_time(working_time, @update_attrs)
    end

    test "update_working_time/2 with invalid data returns error changeset" do
      working_time = working_time_fixture()
      assert {:error, %Ecto.Changeset{}} = Operations.update_working_time(working_time, @invalid_attrs)
      assert working_time == Operations.get_working_time!(working_time.id)
    end

    test "delete_working_time/1 deletes the working_time" do
      working_time = working_time_fixture()
      assert {:ok, %WorkingTime{}} = Operations.delete_working_time(working_time)
      assert_raise Ecto.NoResultsError, fn -> Operations.get_working_time!(working_time.id) end
    end

    test "change_working_time/1 returns a working_time changeset" do
      working_time = working_time_fixture()
      assert %Ecto.Changeset{} = Operations.change_working_time(working_time)
    end
  end
end
