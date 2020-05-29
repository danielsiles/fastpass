defmodule FastpassWeb.Schema.Tickets.TicketSubscriptions do
  use Absinthe.Schema.Notation
  
    alias Fastpass.Tickets
    alias FastpassWeb.Resolvers
    alias FastpassWeb.Middlewares.Authorize
  
    object :ticket_subscriptions do
      field :new_ticket, :ticket do
        arg :branch_id, :string |> non_null
        config(fn args, _info ->
          {:ok, topic: "ticket:branch:" <> args.branch_id}
        end)
  
        trigger(:create_ticket,
          topic: fn ticket ->
            "ticket:branch:" <> Fastpass.Tickets.get_branch_id(ticket)
          end
        )
  
        trigger(:create_booking,
          topic: fn ticket ->
            "ticket:branch:" <> Fastpass.Tickets.get_branch_id(ticket)
          end
        )
  
        resolve(fn root, _, _ ->
          root = root
          |> Repo.preload([:service])
          {:ok, root}
        end)
      end  

      field :call_ticket, :ticket do
        arg :ticket_id, :string |> non_null
        config(fn args, _info ->
          {:ok, topic: "ticket:service:" <> Tickets.get_ticket!(args.ticket_id).service_id}
        end)
  
        trigger(:call_next_ticket,
          topic: fn ticket ->
            "ticket:service:" <> ticket.service_id
          end
        )
  
        resolve(fn _, args, _ ->
          {:ok, Tickets.get_ticket!(args.ticket_id)}
        end)
      end  
    end
  end
  