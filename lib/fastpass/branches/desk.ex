defmodule Fastpass.Branches.Desk do
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.SoftDelete.Schema

  alias Fastpass.Branches.Branch

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "desks" do
    field :name, :string
    belongs_to(:branch, Branch)

    timestamps()
    soft_delete_schema()
  end

  @required_fields ~w(name branch_id)a
  @optional_fields ~w()a

  @doc false
  def changeset(desk, attrs) do
    desk
    |> cast(attrs, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
  end
end
