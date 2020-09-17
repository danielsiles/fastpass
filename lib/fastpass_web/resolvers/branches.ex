defmodule FastpassWeb.Resolvers.BranchResolver do
  alias Fastpass.Branches
  alias Fastpass.Services
  alias Fastpass.Establishments

  def add_branch(
        _,
        %{input: input},
        %{
          context: %{
            current_user: user
          }
        }
      ) do
    Branches.add_branch(user.id, input)
  end

  def add_desk(
        _,
        %{input: input},
        %{
          context: %{
            current_user: user
          }
        }
      ) do
    Branches.add_desk(user.id, input)
  end

  def branches(_, %{latitude: latitude, longitude: longitude}, _) do
    {:ok, Branches.list_branches(latitude, longitude)}
  end

  def branches(_, _, _) do
    {:ok, Branches.list_branches}
  end

  def branch(_, %{branch_id: branch_id}, _) do
    Branches.get_branch(branch_id)
  end

  def services(branch, _, _) do
    {:ok, Services.list_working_services(branch.id)}
  end

  def company(branch, _, _) do
    {:ok, Establishments.get_company!(branch.company_id)}
  end

  def desks(branch, _, _) do
    {:ok, Branches.list_desks(branch)}
  end

end
