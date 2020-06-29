defmodule Fastpass.Services.ServiceStatus do
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.SoftDelete.Schema

  alias Fastpass.Services.Service

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "service_statuses" do
    belongs_to(:service, Service)
    field :status, :string
    timestamps()
    soft_delete_schema()
  end

  @required_fields ~w(service_id status)a
  @optional_fields ~w()a

  @doc false
  def changeset(service_status, attrs) do
    service_status
    |> cast(attrs, [@required_fields ++ @optional_fields])
    |> validate_required([@required_fields])
  end
end
