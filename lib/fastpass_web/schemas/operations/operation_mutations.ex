defmodule FastpassWeb.Schema.Operations.OperationMutations do
  use Absinthe.Schema.Notation

  alias FastpassWeb.Resolvers
  alias FastpassWeb.Middlewares.Authorize

  object :operation_mutations do
    @desc "Create a new working time group"
    field :create_working_time_group, :working_time_group do
      arg(:input, non_null(:working_time_group_input))
      middleware(Authorize, :any)
      resolve(&Resolvers.OperationResolver.create_working_time_group/3)
    end
  end

  input_object :working_time_group_input do
    field :name, :string
    field :company_id, :string
    field :working_times, list_of(:working_time_input |> non_null) |> non_null
  end

  input_object :working_time_input do
    field :week_day, :integer
    field :open_time, :time
    field :close_time, :time
  end

end
