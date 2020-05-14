defmodule Fastpass.Services.DeskService do
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.SoftDelete.Schema
  
  alias Fastpass.Services.Service
  alias Fastpass.Branches.Desk

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "desk_service" do
    belongs_to(:service, Service)
    belongs_to(:desk, Desk)
    field :priority, :integer
    timestamps()
    soft_delete_schema()
  end

  @required_fields ~w(service_id desk_id priority)a
  @optional_fields ~w()a

  @doc false
  def changeset(desk_service, attrs) do
    desk_service
    |> cast(attrs, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
  end
end
