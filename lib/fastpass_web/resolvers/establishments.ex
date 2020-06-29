defmodule FastpassWeb.Resolvers.EstablishmentResolver do
  alias Fastpass.Establishments
  alias Fastpass.Branches

  def create_company(_, %{input: input}, %{context: %{current_user: user}}) do
    Establishments.create_company(user.id, input)
  end

  def list_establishments(_, _, _) do
    Establishments.list_establishments()
  end

  def branch(establishment_staff,_,_) do
    {:ok, Branches.get_branch!(establishment_staff.branch_id)}
  end
  
end
