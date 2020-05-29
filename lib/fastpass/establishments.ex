defmodule Fastpass.Establishments do
  @moduledoc """
  The Establishments context.
  """

  import Ecto.Query, warn: false
  alias Fastpass.Repo

  alias Fastpass.Establishments.{
    EstablishmentOwner,
    Company
  }

  @doc """
  Returns the list of establishment_owners.

  ## Examples

      iex> list_establishment_owners()
      [%EstablishmentOwner{}, ...]

  """
  def list_establishment_owners do
    Repo.all(EstablishmentOwner)
  end

  @doc """
  Gets a single establishment_owner.

  Raises `Ecto.NoResultsError` if the Establishment owner does not exist.

  ## Examples

      iex> get_establishment_owner!(123)
      %EstablishmentOwner{}

      iex> get_establishment_owner!(456)
      ** (Ecto.NoResultsError)

  """
  def get_establishment_owner!(id), do: Repo.get!(EstablishmentOwner, id)

  def get_company!(id), do: Repo.get!(Company, id)

  @doc """
  Creates a establishment_owner.

  ## Examples

      iex> create_establishment_owner(%{field: value})
      {:ok, %EstablishmentOwner{}}

      iex> create_establishment_owner(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_establishment_owner(attrs \\ %{}) do
    %EstablishmentOwner{}
    |> EstablishmentOwner.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a establishment_owner.

  ## Examples

      iex> update_establishment_owner(establishment_owner, %{field: new_value})
      {:ok, %EstablishmentOwner{}}

      iex> update_establishment_owner(establishment_owner, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_establishment_owner(%EstablishmentOwner{} = establishment_owner, attrs) do
    establishment_owner
    |> EstablishmentOwner.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a establishment_owner.

  ## Examples

      iex> delete_establishment_owner(establishment_owner)
      {:ok, %EstablishmentOwner{}}

      iex> delete_establishment_owner(establishment_owner)
      {:error, %Ecto.Changeset{}}

  """
  def delete_establishment_owner(%EstablishmentOwner{} = establishment_owner) do
    Repo.delete(establishment_owner)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking establishment_owner changes.

  ## Examples

      iex> change_establishment_owner(establishment_owner)
      %Ecto.Changeset{source: %EstablishmentOwner{}}

  """
  def change_establishment_owner(%EstablishmentOwner{} = establishment_owner) do
    EstablishmentOwner.changeset(establishment_owner, %{})
  end

  def is_user_owner(user_id, company_id) do
    Repo.exists?(from eo in EstablishmentOwner, where: eo.user_id == ^user_id and eo.company_id == ^company_id)
  end

  def create_company(user_id, attrs \\ %{}) do
    owner = %EstablishmentOwner{
      user_id: user_id
    }
    IO.inspect owner
    %Company{}
    |> Company.changeset(attrs)
    |> Ecto.Changeset.put_assoc(:owners, [owner])
    |> Repo.insert
  end

  def list_establishments do
    {:ok, Repo.all(Company)}
  end

end
