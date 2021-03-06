defmodule Fastpass.Establishments.EstablishmentOwner do
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.SoftDelete.Schema

  alias Fastpass.Establishments.Company

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "establishment_owners" do
    belongs_to(:company, Company)
    belongs_to(:user, User)
    timestamps()
    soft_delete_schema()
  end

  @required_fields ~w(user_id company_id)a
  @optional_fields ~w()a

  @doc false
  def changeset(establishment_owner, attrs) do
    establishment_owner
    |> cast(attrs, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
  end
end
