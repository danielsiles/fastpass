defmodule FastpassWeb.Schema.Services.ServiceQueries do
  use Absinthe.Schema.Notation

  alias FastpassWeb.Resolvers
  alias FastpassWeb.Middlewares.Authorize

  object :service_queries do
    @desc "Get working services"
    field :working_services, list_of(:service) do
      resolve(&Resolvers.ServiceResolver.working_services/3)
    end

    @desc "Get next period of fastpass"
    field :next_fastpass_period, :fastpass_period do
      arg(:service_id, :string)
      resolve(&Resolvers.ServiceResolver.next_fastpass_period/3)
    end
  end

  object :fastpass_period do
    field :minimum_arrival_time, :string
    field :maximum_arrival_time, :string
  end
end
