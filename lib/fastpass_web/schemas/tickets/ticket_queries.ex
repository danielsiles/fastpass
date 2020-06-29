defmodule FastpassWeb.Schema.Tickets.TicketQueries do
  use Absinthe.Schema.Notation

  alias FastpassWeb.Resolvers
  alias FastpassWeb.Middlewares.Authorize

  object :ticket_queries do
    @desc "Create a new ticket"
    field :non_finished_tickets, list_of(:ticket |> non_null) do
      arg(:desk_id, :string)
      middleware(Authorize, :any)
      resolve(&Resolvers.TicketResolver.non_finished_tickets/3)
    end

    @desc "Get all waiting tickets"
    field :waiting_tickets, list_of(:ticket) do
      arg(:branch_id, :string |> non_null)
      middleware(Authorize, :any)
      resolve(&Resolvers.TicketResolver.waiting_tickets/3)
    end

    @desc "Get latest tickets called"
    field :latest_tickets, list_of(:ticket) do
      arg(:branch_id, :string |> non_null)
      middleware(Authorize, :any)
      resolve(&Resolvers.TicketResolver.latest_tickets/3)
    end
  end
end
