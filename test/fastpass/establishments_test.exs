defmodule Fastpass.EstablishmentsTest do
  use Fastpass.DataCase

  alias Fastpass.Establishments

  describe "establishment_owners" do
    alias Fastpass.Establishments.EstablishmentOwner

    @valid_attrs %{}
    @update_attrs %{}
    @invalid_attrs %{}

    def establishment_owner_fixture(attrs \\ %{}) do
      {:ok, establishment_owner} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Establishments.create_establishment_owner()

      establishment_owner
    end

    # test "list_establishment_owners/0 returns all establishment_owners" do
    #   establishment_owner = establishment_owner_fixture()
    #   assert Establishments.list_establishment_owners() == [establishment_owner]
    # end

    # test "get_establishment_owner!/1 returns the establishment_owner with given id" do
    #   establishment_owner = establishment_owner_fixture()
    #   assert Establishments.get_establishment_owner!(establishment_owner.id) == establishment_owner
    # end

    # test "create_establishment_owner/1 with valid data creates a establishment_owner" do
    #   assert {:ok, %EstablishmentOwner{} = establishment_owner} = Establishments.create_establishment_owner(@valid_attrs)
    # end

    # test "create_establishment_owner/1 with invalid data returns error changeset" do
    #   assert {:error, %Ecto.Changeset{}} = Establishments.create_establishment_owner(@invalid_attrs)
    # end

    # test "update_establishment_owner/2 with valid data updates the establishment_owner" do
    #   establishment_owner = establishment_owner_fixture()
    #   assert {:ok, %EstablishmentOwner{} = establishment_owner} = Establishments.update_establishment_owner(establishment_owner, @update_attrs)
    # end

    # test "update_establishment_owner/2 with invalid data returns error changeset" do
    #   establishment_owner = establishment_owner_fixture()
    #   assert {:error, %Ecto.Changeset{}} = Establishments.update_establishment_owner(establishment_owner, @invalid_attrs)
    #   assert establishment_owner == Establishments.get_establishment_owner!(establishment_owner.id)
    # end

    # test "delete_establishment_owner/1 deletes the establishment_owner" do
    #   establishment_owner = establishment_owner_fixture()
    #   assert {:ok, %EstablishmentOwner{}} = Establishments.delete_establishment_owner(establishment_owner)
    #   assert_raise Ecto.NoResultsError, fn -> Establishments.get_establishment_owner!(establishment_owner.id) end
    # end

    # test "change_establishment_owner/1 returns a establishment_owner changeset" do
    #   establishment_owner = establishment_owner_fixture()
    #   assert %Ecto.Changeset{} = Establishments.change_establishment_owner(establishment_owner)
    # end
  end
end
