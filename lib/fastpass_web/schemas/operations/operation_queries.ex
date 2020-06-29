defmodule FastpassWeb.Schema.Operations.OperationQueries do
  use Absinthe.Schema.Notation

  alias FastpassWeb.Resolvers
  alias FastpassWeb.Middlewares.Authorize

  object :operation_queries do
    @desc "Get working time groups of the company"
    field :working_time_group, list_of(:working_time_group |> non_null) do
      arg(:company_id, non_null(:string))
      middleware(Authorize, :any)
      resolve(&Resolvers.OperationResolver.working_time_group/3)
    end
  end
end
