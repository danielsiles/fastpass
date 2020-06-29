defmodule Fastpass.Branches.Branch do
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.SoftDelete.Schema
  import EctoEnum

  alias Fastpass.Establishments.Company
  alias Fastpass.Operations.WorkingTimeGroup
  alias Fastpass.Branches.BranchStatus
  alias Fastpass.Services.Service

  defenum BranchStatusEnum, ["active", "inactive"]

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "branches" do
    field :name, :string
    field :latitude, :string
    field :longitude, :string
    field :country, :string, null: false
    field :state, :string, null: false
    field :city, :string, null: false
    field :neighborhood, :string, null: false
    field :street, :string, null: false
    field :number, :string, null: false
    field :complement, :string
    field :status, BranchStatusEnum

    belongs_to(:company, Company)
    belongs_to(:working_time_group, WorkingTimeGroup)
    has_many(:statuses, BranchStatus)
    has_many(:services, Service)

    timestamps()
    soft_delete_schema()
  end

  @required_fields ~w(name latitude longitude company_id country state city neighborhood street number status)a
  @optional_fields ~w(complement working_time_group_id)a

  @doc false
  def changeset(branch, attrs) do
    branch
    |> cast(attrs, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
  end
end
