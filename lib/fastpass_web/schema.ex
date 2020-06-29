defmodule FastpassWeb.Schema do
  use Absinthe.Schema
  import Ecto.Query, warn: false
  import Absinthe.Resolution.Helpers, only: [dataloader: 1, dataloader: 3]

  alias Fastpass.Repo

  alias FastpassWeb.Schema.{
    Accounts,
    Branches,
    Establishments,
    Operations,
    Services,
    Tickets
  }

  import_types(Absinthe.Type.Custom)
  # Accounts
  import_types(Accounts.{
    UserType,
    UserQueries,
    UserMutations,
    SessionType,
    SessionMutations
  })

  import_types(Branches.{BranchTypes, BranchMutations, BranchQueries})
  import_types(Establishments.{EstablishmentTypes, EstablishmentMutations, EstablishmentQueries})
  import_types(Operations.{OperationTypes, OperationQueries, OperationMutations})
  import_types(Services.{ServiceTypes, ServiceMutations, ServiceQueries})
  import_types(Tickets.{TicketTypes, TicketQueries, TicketMutations, TicketSubscriptions})

  query do
    import_fields(:user_queries)
    import_fields(:establishment_queries)
    import_fields(:branch_queries)
    import_fields(:service_queries)
    import_fields(:ticket_queries)
    import_fields(:operation_queries)
  end

  mutation do
    import_fields(:user_mutations)
    import_fields(:session_mutations)
    import_fields(:establishment_mutations)
    import_fields(:branch_mutations)
    import_fields(:service_mutations)
    import_fields(:operation_mutations)
    import_fields(:ticket_mutations)
  end

  subscription do
    import_fields(:ticket_subscriptions)
  end

  def context(ctx) do
    loader =
      Dataloader.new()
      |> Dataloader.add_source(Fastpass.Tickets, Fastpass.Tickets.datasource())
      |> Dataloader.add_source(Fastpass.Services, Fastpass.Services.datasource())
      |> Dataloader.add_source(Fastpass.Branches, Fastpass.Branches.datasource())
      |> Dataloader.add_source(Fastpass.Establishments, Fastpass.Establishments.datasource())
      |> Dataloader.add_source(Fastpass.Operations, Fastpass.Operations.datasource())

    Map.put(ctx, :loader, loader)
  end

  def middleware(middleware, _field, %{identifier: :mutation}) do
    middleware ++ [FastpassWeb.Middlewares.ErrorHandler]
  end

  # if it's any other object keep things as is
  def middleware(middleware, _field, _object), do: middleware

  def plugins do
    [Absinthe.Middleware.Dataloader] ++ Absinthe.Plugin.defaults()
  end
end
