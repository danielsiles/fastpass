defmodule Fastpass.Branches.BranchStatus do
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.SoftDelete.Schema
  import EctoEnum

  alias Fastpass.Branches.Branch

  defenum BranchStatusEnum, ["active", "inactive"]

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "branch_statuses" do
    belongs_to(:branch, Branch)
    field :status, BranchStatusEnum
    timestamps()
    soft_delete_schema()
  end

  @required_fields ~w(branch_id status)a
  @optional_fields ~w()a

  @doc false
  def changeset(branch_status, attrs) do
    branch_status
    |> cast(attrs, [@required_fields ++ @optional_fields])
    |> validate_required([@required_fields])
  end
end
