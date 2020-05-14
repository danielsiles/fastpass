defmodule Fastpass.Services do
  @moduledoc """
  The Services context.
  """

  import Ecto.Query, warn: false
  alias Fastpass.Repo

  alias Fastpass.Services.{
    Service,
    ServiceStatus,
    DeskService
  }
  alias Fastpass.Operations.{
    WorkingTimeGroup,
    WorkingTime
  }
  alias Fastpass.Branches
  alias Fastpass.Tickets

  @doc """
  Returns the list of services.

  ## Examples

      iex> list_services()
      [%Service{}, ...]

  """
  def list_services do
    Repo.all(Service)
  end

  @doc """
  Gets a single service.

  Raises `Ecto.NoResultsError` if the Service does not exist.

  ## Examples

      iex> get_service!(123)
      %Service{}

      iex> get_service!(456)
      ** (Ecto.NoResultsError)

  """
  def get_service!(id), do: Repo.get!(Service, id)

  @doc """
  Creates a service.

  ## Examples

      iex> create_service(%{field: value})
      {:ok, %Service{}}

      iex> create_service(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_service(attrs \\ %{}) do
    %Service{}
    |> Service.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a service.

  ## Examples

      iex> update_service(service, %{field: new_value})
      {:ok, %Service{}}

      iex> update_service(service, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_service(%Service{} = service, attrs) do
    service
    |> Service.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a service.

  ## Examples

      iex> delete_service(service)
      {:ok, %Service{}}

      iex> delete_service(service)
      {:error, %Ecto.Changeset{}}

  """
  def delete_service(%Service{} = service) do
    Repo.delete(service)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking service changes.

  ## Examples

      iex> change_service(service)
      %Ecto.Changeset{source: %Service{}}

  """
  def change_service(%Service{} = service) do
    Service.changeset(service, %{})
  end

  def add_service(user_id, attrs \\ %{}) do
    case Branches.is_user_owner(user_id, attrs.branch_id) do
      true -> 
        %Service{}
        |> Service.changeset(attrs)
        |> Ecto.Changeset.put_assoc(:statuses, [%ServiceStatus{status: :active}])
        |> Repo.insert()
      _ ->
        {:error, "You cannot add a service to a branch that you don't own"}  
    end
  end

  def is_working(service_id) do
    today = Date.utc_today
    week_day = Date.day_of_week(today) 
    time = Time.utc_now
    query = from s in Service,
    join: wtg in WorkingTimeGroup, on: s.working_time_group_id == wtg.id,
    join: wt in WorkingTime, on: wt.working_time_group_id == wtg.id,
    where: wt.week_day == ^week_day,
    where: s.id == ^service_id,
    where: wt.open_time < ^time,
    where: wt.close_time > ^time,
    select: wt
    Repo.exists?(query)
  end

  def set_desk_service(user_id, attrs \\ %{}) do
    Repo.transaction(fn ->
      results = 
      Enum.map(attrs, fn desk_service -> 
        case Branches.is_user_owner(user_id, desk_service.desk_id, :desk) and Branches.is_user_owner(user_id, desk_service.service_id, :service) do
          true -> 
            %DeskService{}
            |> DeskService.changeset(desk_service)
            |> Repo.insert!()
          _ ->
            {:error, "You cannot add a service to a desk or branch that you don't own"}  
        end
      end)
      results
    end)
  end

  def list_working_services do # fazer uma versao que da join com branches
    today = Date.utc_today
    week_day = Date.day_of_week(today) 
    time = Time.utc_now
    query = from s in Service,
    join: wtg in WorkingTimeGroup, on: s.working_time_group_id == wtg.id,
    join: wt in WorkingTime, on: wt.working_time_group_id == wtg.id,
    where: wt.week_day == ^week_day,
    where: wt.open_time < ^time,
    where: wt.close_time > ^time,
    select: s
    Repo.all(query)
end

  def next_fastpass_period(service_id) do
    with ({minimum_arrival_time, maximum_arrival_time} <- Tickets.get_next_fastpass_period(service_id, false)) do 
      {:ok, %{
        minimum_arrival_time: minimum_arrival_time,
        maximum_arrival_time: maximum_arrival_time
      }}
    else
      _ -> {:error, "Ocorreu um erro"}
    end
  end
end
