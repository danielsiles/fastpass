defmodule Fastpass.Operations do
  @moduledoc """
  The Operations context.
  """

  import Ecto.Query, warn: false
  alias Fastpass.Repo

  alias Fastpass.Operations.{
    WorkingTimeGroup,
    WorkingTime
  }
  alias Fastpass.Establishments
  @doc """
  Returns the list of working_times.

  ## Examples

      iex> list_working_times()
      [%WorkingTime{}, ...]

  """
  def list_working_times do
    Repo.all(WorkingTime)
  end

  @doc """
  Gets a single working_time.

  Raises `Ecto.NoResultsError` if the Working time does not exist.

  ## Examples

      iex> get_working_time!(123)
      %WorkingTime{}

      iex> get_working_time!(456)
      ** (Ecto.NoResultsError)

  """
  def get_working_time!(id), do: Repo.get!(WorkingTime, id)

  @doc """
  Creates a working_time.

  ## Examples

      iex> create_working_time(%{field: value})
      {:ok, %WorkingTime{}}

      iex> create_working_time(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_working_time(attrs \\ %{}) do
    %WorkingTime{}
    |> WorkingTime.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a working_time.

  ## Examples

      iex> update_working_time(working_time, %{field: new_value})
      {:ok, %WorkingTime{}}

      iex> update_working_time(working_time, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_working_time(%WorkingTime{} = working_time, attrs) do
    working_time
    |> WorkingTime.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a working_time.

  ## Examples

      iex> delete_working_time(working_time)
      {:ok, %WorkingTime{}}

      iex> delete_working_time(working_time)
      {:error, %Ecto.Changeset{}}

  """
  def delete_working_time(%WorkingTime{} = working_time) do
    Repo.delete(working_time)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking working_time changes.

  ## Examples

      iex> change_working_time(working_time)
      %Ecto.Changeset{source: %WorkingTime{}}

  """
  def change_working_time(%WorkingTime{} = working_time) do
    WorkingTime.changeset(working_time, %{})
  end

  def create_working_time_group(user_id, attrs \\ %{}) do 
    Repo.transaction(fn ->
      case Establishments.is_user_owner(user_id, attrs.company_id) do
        true -> 
          working_time_group = %WorkingTimeGroup{}
          |> WorkingTimeGroup.changeset(attrs)
          |> Repo.insert!()
          |> IO.inspect

          Enum.map(attrs.working_times, fn working_time -> 
            %WorkingTime{}
            |> WorkingTime.changeset(Map.put(working_time, :working_time_group_id, working_time_group.id))
            |> IO.inspect
            |> Repo.insert!()
          end)
          working_time_group
        _ ->
          {:error, "You cannot add a service to a desk or branch that you don't own"}  
      end
    end)
  end

  def working_time_group(company_id) do
    query = from wtg in WorkingTimeGroup,
    where: wtg.company_id == ^company_id,
    select: wtg

    Repo.all(query)
  end

  def datasource() do
    Dataloader.Ecto.new(Fastpass.Repo, query: &query/2)
  end

  def query(queryable, _) do
    queryable
  end
end
