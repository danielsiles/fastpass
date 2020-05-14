defmodule FastpassWeb.Schema.Branches.BranchMutations do
  use Absinthe.Schema.Notation

  alias FastpassWeb.Resolvers
  alias FastpassWeb.Middlewares.Authorize

  object :branch_mutations do
    @desc "Adds a branch to a company"
    field :add_branch, :branch do
      arg(:input, non_null(:branch_input))
      middleware(Authorize, :any)
      resolve(&Resolvers.BranchResolver.add_branch/3)
    end

    @desc "Adds a desk to a branch"
    field :add_desk, :desk do
      arg(:input, non_null(:desk_input))
      middleware(Authorize, :any)
      resolve(&Resolvers.BranchResolver.add_desk/3)
    end
  end

  input_object :branch_input do
    field :name, :string |> non_null
    field :latitude, :string |> non_null
    field :longitude, :string |> non_null
    field :country, :string |> non_null
    field :state, :string |> non_null
    field :city, :string |> non_null
    field :neighborhood, :string |> non_null
    field :street, :string |> non_null
    field :number, :string |> non_null
    field :complement, :string

    field :company_id, :string |> non_null
    field :working_time_group_id, :string
  end

  input_object :desk_input do
    field :name, :string |> non_null
    field :branch_id, :string |> non_null
  end
end
