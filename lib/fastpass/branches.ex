defmodule Fastpass.Branches do
  @moduledoc """
  The Branches context.
  """
  
  import Ecto.Query, warn: false
  alias Fastpass.Repo

  alias Fastpass.Branches
  alias Fastpass.Branches.{
    Branch,
    BranchStatus,
    Desk
  }
  alias Fastpass.Establishments
  alias Fastpass.Establishments.Company
  alias Fastpass.Operations.{
    WorkingTimeGroup,
    WorkingTime
  }
  alias Fastpass.Tickets.Ticket

  @doc """
  Gets a single branch.

  Raises `Ecto.NoResultsError` if the Branch does not exist.

  ## Examples

      iex> get_branch!(123)
      %Branch{}

      iex> get_branch!(456)
      ** (Ecto.NoResultsError)

  """
  def get_branch!(id), do: Repo.get!(Branch, id)

  @doc """
  Creates a branch.

  ## Examples

      iex> create_branch(%{field: value})
      {:ok, %Branch{}}

      iex> create_branch(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_branch(attrs \\ %{}) do
    %Branch{}
    |> Branch.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a branch.

  ## Examples

      iex> update_branch(branch, %{field: new_value})
      {:ok, %Branch{}}

      iex> update_branch(branch, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_branch(%Branch{} = branch, attrs) do
    branch
    |> Branch.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a branch.

  ## Examples

      iex> delete_branch(branch)
      {:ok, %Branch{}}

      iex> delete_branch(branch)
      {:error, %Ecto.Changeset{}}

  """
  def delete_branch(%Branch{} = branch) do
    Repo.delete(branch)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking branch changes.

  ## Examples

      iex> change_branch(branch)
      %Ecto.Changeset{source: %Branch{}}

  """
  def change_branch(%Branch{} = branch) do
    Branch.changeset(branch, %{})
  end

  def is_working(branch_id) do
    today = Date.utc_today
    week_day = Date.day_of_week(today) 
    time = Time.utc_now
    query = from b in Branch,
    join: wtg in WorkingTimeGroup, on: b.working_time_group_id == wtg.id,
    join: wt in WorkingTime, on: wt.working_time_group_id == wtg.id,
    where: wt.week_day == ^week_day,
    where: b.id == ^branch_id,
    where: wt.open_time < ^time,
    where: wt.close_time > ^time,
    select: wt
    Repo.exists?(query)
  end

  def is_user_owner(user_id, branch_id, type \\ :branch) when type == :branch do
    q = "select TRUE from 
    branches as b, companies as c, establishment_owners as eo 
    where eo.company_id = c.id and b.company_id = c.id and 
    b.id = $1 and 
    eo.user_id = $2"
    {:ok,branch} = Ecto.UUID.dump(branch_id)
    {:ok,user} = Ecto.UUID.dump(user_id)
    with (%{rows: [[result]]} <- Ecto.Adapters.SQL.query!(Repo, q, [branch, user])) do
      result
    else
      _ -> false
    end
  end

  def is_user_owner(user_id, desk_id, type) when type == :desk do
    q = "select TRUE from 
    desks as d, branches as b, companies as c, establishment_owners as eo 
    where d.branch_id = b.id and eo.company_id = c.id and b.company_id = c.id and 
    d.id = $1 and 
    eo.user_id = $2"
    {:ok,desk} = Ecto.UUID.dump(desk_id)
    {:ok,user} = Ecto.UUID.dump(user_id)
    with (%{rows: [[result]]} <- Ecto.Adapters.SQL.query!(Repo, q, [desk, user])) do
      result
    else
      _ -> false
    end
  end

  def is_user_owner(user_id, service_id, type) when type == :service do
    q = "select TRUE from 
    services as s, branches as b, companies as c, establishment_owners as eo 
    where s.branch_id = b.id and eo.company_id = c.id and b.company_id = c.id and 
    s.id = $1 and 
    eo.user_id = $2"
    {:ok,service} = Ecto.UUID.dump(service_id)
    {:ok,user} = Ecto.UUID.dump(user_id)
    with (%{rows: [[result]]} <- Ecto.Adapters.SQL.query!(Repo, q, [service, user])) do
      result
    else
      _ -> false
    end
  end

  def add_branch(user_id, attrs \\ %{}) do
    case Establishments.is_user_owner(user_id, attrs.company_id) do
      true -> 
        %Branch{}
        |> Branch.changeset(attrs)
        |> Ecto.Changeset.put_assoc(:statuses, [%BranchStatus{status: :active}])
        |> Repo.insert
      _ ->
        {:error, "You cannot add a branch to a company that you don't own"}  
    end
  end

  def add_desk(user_id, attrs \\ %{}) do
    case Branches.is_user_owner(user_id, attrs.branch_id) do
      true -> 
        %Desk{}
        |> Desk.changeset(attrs)
        |> Repo.insert
      _ ->
        {:error, "You cannot add a desk to a branch that you don't own"}  
    end
  end

  def list_branches do
    Repo.all(Branch)
  end

end
