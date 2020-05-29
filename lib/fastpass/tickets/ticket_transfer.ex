defmodule Fastpass.Tickets.TicketTransfer do
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.SoftDelete.Schema
  import EctoEnum

  alias Fastpass.Services.Service
  alias Fastpass.Accounts.User
  alias Fastpass.Tickets.Ticket

  defenum TransferTypeEnum, ["first", "last"]

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "ticket_transfers" do
    belongs_to(:old_service, Service)
    belongs_to(:new_service, Service)
    belongs_to(:old_user, User)
    belongs_to(:new_user, User)
    belongs_to(:ticket, Ticket)
    field :type, TransferTypeEnum
    timestamps()
    soft_delete_schema()
  end

  @required_fields ~w(old_service_id new_service_id old_user_id new_user_id ticket_id type)a
  @optional_fields ~w()a

  @doc false
  def changeset(ticket_transfer, attrs) do
    ticket_transfer
    |> cast(attrs, [@required_fields ++ @optional_fields])
    |> validate_required([@required_fields])
  end
end
