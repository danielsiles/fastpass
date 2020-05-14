defmodule FastpassWeb.Schema.Branches.BranchQueries do
  use Absinthe.Schema.Notation

  alias FastpassWeb.Resolvers
  alias FastpassWeb.Middlewares.Authorize

  object :branch_queries do
    @desc "List branches"
    field :branches, list_of(:branch) do # Paginate later
      resolve(&Resolvers.BranchResolver.branches/3)
    end
  end
end
