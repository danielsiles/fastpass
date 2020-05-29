defmodule Fastpass.Services.Service do
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.SoftDelete.Schema

  alias Fastpass.Operations.WorkingTimeGroup
  alias Fastpass.Branches.Branch
  alias Fastpass.Services.ServiceStatus

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "services" do
    field :name, :string
    field :service_letter, :string
    belongs_to(:branch, Branch)
    belongs_to(:working_time_group, WorkingTimeGroup)

    has_many(:statuses, ServiceStatus)

    timestamps()
    soft_delete_schema()
  end

  @required_fields ~w(name service_letter branch_id)a
  @optional_fields ~w(working_time_group_id)a

  @doc false
  def changeset(service, attrs) do
    service
    |> cast(attrs, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
  end
end
