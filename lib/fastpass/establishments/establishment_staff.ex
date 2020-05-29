defmodule Fastpass.Establishments.EstablishmentStaff do
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.SoftDelete.Schema

  alias Fastpass.Accounts.User
  alias Fastpass.Branches.Branch

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "establishment_staffs" do
    # TODO belongs to a branch (ONE TO ONE)
    belongs_to(:user, User)
    belongs_to(:branch, Branch)
    field :role, :string
    timestamps()
    soft_delete_schema()
  end

  @required_fields ~w(user_id branch_id role)a
  @optional_fields ~w()a

  @doc false
  def changeset(establishment_staff, attrs) do
    establishment_staff
    |> cast(attrs, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
  end
end
