defmodule Fastpass.Tickets.Booking do
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.SoftDelete.Schema

  alias Fastpass.Tickets.Ticket

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "bookings" do
    belongs_to(:ticket, Ticket)
    field :minimum_arrival_time, :naive_datetime
    field :maximum_arrival_time, :naive_datetime
    field :check_in, :naive_datetime
    timestamps()
    soft_delete_schema()
  end

  @required_fields ~w(minimum_arrival_time maximum_arrival_time)a
  @optional_fields ~w(check_in)a

  @doc false
  def changeset(booking, attrs) do
    booking
    |> cast(attrs, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
  end
end
