defmodule Fastpass.BranchesTest do
  use Fastpass.DataCase

  alias Fastpass.Branches

  describe "branches" do
    alias Fastpass.Branches.Branch

    @valid_attrs %{}
    @update_attrs %{}
    @invalid_attrs %{}

    def branch_fixture(attrs \\ %{}) do
      {:ok, branch} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Branches.create_branch()

      branch
    end

    test "list_branches/0 returns all branches" do
      branch = branch_fixture()
      assert Branches.list_branches() == [branch]
    end

    test "get_branch!/1 returns the branch with given id" do
      branch = branch_fixture()
      assert Branches.get_branch!(branch.id) == branch
    end

    test "create_branch/1 with valid data creates a branch" do
      assert {:ok, %Branch{} = branch} = Branches.create_branch(@valid_attrs)
    end

    test "create_branch/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Branches.create_branch(@invalid_attrs)
    end

    test "update_branch/2 with valid data updates the branch" do
      branch = branch_fixture()
      assert {:ok, %Branch{} = branch} = Branches.update_branch(branch, @update_attrs)
    end

    test "update_branch/2 with invalid data returns error changeset" do
      branch = branch_fixture()
      assert {:error, %Ecto.Changeset{}} = Branches.update_branch(branch, @invalid_attrs)
      assert branch == Branches.get_branch!(branch.id)
    end

    test "delete_branch/1 deletes the branch" do
      branch = branch_fixture()
      assert {:ok, %Branch{}} = Branches.delete_branch(branch)
      assert_raise Ecto.NoResultsError, fn -> Branches.get_branch!(branch.id) end
    end

    test "change_branch/1 returns a branch changeset" do
      branch = branch_fixture()
      assert %Ecto.Changeset{} = Branches.change_branch(branch)
    end
  end
end
