defmodule Fastpass.Tickets.Ticket do
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.SoftDelete.Schema
  import EctoEnum

  alias Fastpass.Accounts.User
  alias Fastpass.Services.Service
  alias Fastpass.Tickets.{
    Booking,
    TicketAction,
    TicketTransfer
  }

  defenum BookingFromTypeEnum, ["web", "app", "host"]
  defenum TicketStatusEnum, ["waiting", "done", "canceled", "no_show", "called", "recalled", "arrived"]

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "tickets" do
    belongs_to(:service, Service)
    belongs_to(:user, User)
    field :is_fastpass, :boolean
    field :booking_from, BookingFromTypeEnum
    field :waiting_time, :integer
    field :serving_time, :integer
    field :called_count, :integer
    field :done_count, :integer
    field :ticket_number, :string
    field :priority, :boolean
    field :status, TicketStatusEnum

    has_one :booking, Booking
    has_many :actions, TicketAction
    has_many :transfers, TicketTransfer

    timestamps()
    soft_delete_schema()
  end

  @required_fields ~w(service_id user_id booking_from status)a
  @optional_fields ~w( waiting_time serving_time called_count done_count priority is_fastpass ticket_number)a

  @doc false
  def changeset(ticket, attrs) do
    ticket
    |> cast(attrs, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
  end
end
