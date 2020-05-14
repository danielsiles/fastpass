defmodule FastpassWeb.Schema do
  use Absinthe.Schema
  
  alias FastpassWeb.Schema.{
    Accounts, Branches, Establishments,
    Operations, Services, Tickets
  }
  
  import_types(Absinthe.Type.Custom)
  # Accounts
  import_types(Accounts.{
    UserType, UserQueries, UserMutations,
    SessionType, SessionMutations
  })

  import_types(Branches.{BranchTypes, BranchMutations, BranchQueries})
  import_types(Establishments.{EstablishmentTypes, EstablishmentMutations, EstablishmentQueries})
  import_types(Operations.{OperationTypes, OperationMutations})
  import_types(Services.{ServiceTypes, ServiceMutations, ServiceQueries})
  import_types(Tickets.{TicketTypes, TicketMutations})
  
  query do
    import_fields(:user_queries)
    import_fields(:establishment_queries)
    import_fields(:branch_queries)
    import_fields(:service_queries)
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
    field :new_ticket, :ticket do
      config fn _args, _info -> 
        {:ok, topic: "*"}
      end

      trigger :create_ticket, topic: fn _ticket ->
        "*"
      end

      resolve fn root, _, _ ->
        IO.inspect root
        {:ok, root}
      end
    end
  end
end 
