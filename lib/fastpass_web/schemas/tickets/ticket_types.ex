defmodule FastpassWeb.Schema.Tickets.TicketTypes do
    use Absinthe.Schema.Notation
  
    alias FastpassWeb.Resolvers

    enum :ticket_booking_from_enum do
      value :web
      value :app
      value :host
    end

    object :ticket do
      field :id, :id
      field :service, :service
      field :user, :user
      field :is_fastpass, :boolean
      field :booking_from, :ticket_booking_from_enum
      field :waiting_time, :integer
      field :serving_time, :integer
      field :called_count, :integer
      field :done_count, :integer
      field :ticket_number, :string
      field :priority, :boolean

      field :ticket_actions, list_of(:ticket_action |> non_null)
      field :ticket_transfers, list_of(:ticket_transfer |> non_null)
      field :booking, :booking
      
      field :inserted_at, :naive_datetime
      field :updated_at, :naive_datetime
      field :deleted_at, :naive_datetime
    end

    enum :ticket_status_enum do
      value :waiting
      value :done
      value :canceled
      value :no_show
      value :called
      value :recalled
      value :arrived
    end
    
    enum :ticket_action_enum do
      value :book
      value :call
      value :recall
      value :transfer
      value :done
      value :cancel
      value :confirm_arrival
    end

    object :ticket_action do
      field :id, :id
      field :ticket, :ticket
      field :actor, :establishment_staff
      field :status, :ticket_status_enum
      field :action, :ticket_action_enum

      field :inserted_at, :naive_datetime
      field :updated_at, :naive_datetime
      field :deleted_at, :naive_datetime
    end

    enum :transfer_type_enum do
      value :first
      value :last
    end

    object :ticket_transfer do
      field :id, :id
      field :old_service, :service
      field :new_service, :service
      field :old_user, :user
      field :new_user, :user
      field :ticket, :ticket
      field :type, :transfer_type_enum

      field :inserted_at, :naive_datetime
      field :updated_at, :naive_datetime
      field :deleted_at, :naive_datetime
    end

    object :booking do
      field :id, :id
      field :ticket, :ticket
      field :minimum_arrival_time, :naive_datetime
      field :maximum_arrival_time, :naive_datetime

      field :inserted_at, :naive_datetime
      field :updated_at, :naive_datetime
      field :deleted_at, :naive_datetime
    end
  end
  