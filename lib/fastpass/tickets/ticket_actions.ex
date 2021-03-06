defmodule Fastpass.Tickets.TicketAction do
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.SoftDelete.Schema
  import EctoEnum

  alias Fastpass.Tickets.Ticket
  alias Fastpass.Accounts.User

  defenum TicketActionTypeEnum, ["book", "call", "recall", "transfer", "done", "cancel", "confirm_arrival"]
  
  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "ticket_actions" do
    belongs_to(:ticket, Ticket, type: :binary_id)
    belongs_to(:actor, User, source: :actor, references: :id)
    field :status, :string
    field :action, TicketActionTypeEnum
    # field :actor, :binary_id
    timestamps()
    soft_delete_schema()
  end

  @required_fields ~w(ticket_id status action actor_id)a
  @optional_fields ~w()a

  @doc false
  def changeset(ticket_actions, attrs) do
    ticket_actions
    |> cast(attrs, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
  end
end
