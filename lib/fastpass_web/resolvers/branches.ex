defmodule FastpassWeb.Resolvers.BranchResolver do
  alias Fastpass.Branches
  # alias Fastpass.Establishments.Company

  def add_branch(_, %{input: input}, %{context: %{current_user: user}}) do
    Branches.add_branch(user.id, input)
  end

  def add_desk(_, %{input: input}, %{context: %{current_user: user}}) do
    Branches.add_desk(user.id, input)
  end

  def branches(_, _, _) do
    {:ok, Branches.list_branches}
  end
  
end
