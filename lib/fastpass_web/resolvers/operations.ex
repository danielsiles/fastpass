defmodule FastpassWeb.Resolvers.OperationResolver do
  alias Fastpass.Operations
  # alias Fastpass.Establishments.Company

  def create_working_time_group(_, %{input: input}, %{context: %{current_user: user}}) do
    Operations.create_working_time_group(user.id, input)
  end

  def working_time_group(_, %{company_id: company_id}, %{context: %{current_user: user}}) do
    {:ok, Operations.working_time_group(company_id)}
  end
  
end
