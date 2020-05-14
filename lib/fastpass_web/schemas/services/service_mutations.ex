defmodule FastpassWeb.Schema.Services.ServiceMutations do
  use Absinthe.Schema.Notation

  alias FastpassWeb.Resolvers
  alias FastpassWeb.Middlewares.Authorize

  object :service_mutations do
    @desc "Create a new service"
    field :add_service, :service do
      arg(:input, non_null(:service_input))
      middleware(Authorize, :any)
      resolve(&Resolvers.ServiceResolver.add_service/3)
    end

    @desc "Set services for a desk"
    field :set_desk_service, list_of(:desk_service) do
      arg(:input, list_of(:desk_service_input |> non_null) |> non_null)
      middleware(Authorize, :any)
      resolve(&Resolvers.ServiceResolver.set_desk_service/3)
    end
  end

  input_object :service_input do
    field :name, :string |> non_null
    field :service_letter, :string |> non_null
    field :branch_id, :string |> non_null
    field :working_time_group_id, :string
  end

  input_object :desk_service_input do
    field :desk_id, :string |> non_null
    field :priority, :integer |> non_null
    field :service_id, :string |> non_null
  end

end
