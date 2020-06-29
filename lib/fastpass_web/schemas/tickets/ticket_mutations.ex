defmodule FastpassWeb.Schema.Tickets.TicketMutations do
  use Absinthe.Schema.Notation

  alias FastpassWeb.Resolvers
  alias FastpassWeb.Middlewares.Authorize

  object :ticket_mutations do
    @desc "Create a new ticket"
    field :create_ticket, :ticket do
      arg(:input, non_null(:ticket_input))
      middleware(Authorize, :any)
      resolve(&Resolvers.TicketResolver.create_ticket/3)
    end

    @desc "Create a booking ticket"
    field :create_booking, :ticket do
      arg(:input, non_null(:ticket_input))
      middleware(Authorize, :any)
      resolve(&Resolvers.TicketResolver.create_booking/3)
    end

    @desc "Check in a booking"
    field :check_in_booking, :ticket do
      arg(:ticket_id, :string |> non_null)
      middleware(Authorize, :any)
      resolve(&Resolvers.TicketResolver.check_in_booking/3)

    end
    @desc "Call next ticket in line"
    field :call_next_ticket, :ticket do
      arg(:desk_id, :string |> non_null)
      middleware(Authorize, :any)
      resolve(&Resolvers.TicketResolver.call_next_ticket/3)
    end

    @desc "Call specific service next ticket in line"
    field :call_next_ticket_by_service, :ticket do
      arg(:desk_id, :string |> non_null)
      arg(:service_id, :string |> non_null)
      middleware(Authorize, :any)
      resolve(&Resolvers.TicketResolver.call_next_ticket/3)
    end

    @desc "Confirm ticket"
    field :confirm_ticket, :ticket_action do
      arg(:ticket_id, :string |> non_null)
      middleware(Authorize, :any)
      resolve(&Resolvers.TicketResolver.confirm_ticket/3)
    end

    @desc "Recall ticket"
    field :recall_ticket, :ticket_action do
      arg(:ticket_id, :string |> non_null)
      middleware(Authorize, :any)
      resolve(&Resolvers.TicketResolver.recall_ticket/3)
    end
    
    @desc "Absent ticket"
    field :absent_ticket, :ticket_action do
      arg(:ticket_id, :string |> non_null)
      middleware(Authorize, :any)
      resolve(&Resolvers.TicketResolver.absent_ticket/3)
    end

    @desc "Cancel ticket"
    field :cancel_ticket, :ticket_action do
      arg(:ticket_id, :string |> non_null)
      middleware(Authorize, :any)
      resolve(&Resolvers.TicketResolver.cancel_ticket/3)
    end

    @desc "Finalize ticket"
    field :finalize_ticket, :ticket_action do
      arg(:ticket_id, :string |> non_null)
      middleware(Authorize, :any)
      resolve(&Resolvers.TicketResolver.finalize_ticket/3)
    end

    @desc "Trasfer ticket"
    field :transfer_ticket, :ticket_action do
      arg(:ticket_id, :string |> non_null)
      arg(:service_id, :string |> non_null)
      middleware(Authorize, :any)
      resolve(&Resolvers.TicketResolver.transfer_ticket/3)
    end

    @desc "Create a new ticket"
    field :host_create_ticket, :ticket do
      arg(:input, non_null(:host_ticket_input))
      middleware(Authorize, :any)
      resolve(&Resolvers.TicketResolver.host_create_ticket/3)
    end
  end

  input_object :ticket_input do
    field :service_id, :string |> non_null
    field :booking_from, :ticket_booking_from_enum |> non_null
    field :priority, :boolean |> non_null
  end

  input_object :host_ticket_input do
    field :service_id, :string |> non_null
    field :user_id, :string |> non_null
    field :priority, :boolean |> non_null
  end
end
