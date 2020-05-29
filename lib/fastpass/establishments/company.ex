defmodule Fastpass.Establishments.Company do
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.SoftDelete.Schema
  import EctoEnum

  alias Fastpass.Establishments.{
    EstablishmentOwner,
    EstablishmentStaff,
  }

  defenum CompanyTypeEnum, ["restaurant", "post_office", "bank"]

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "companies" do
    field :name, :string
    field :document_number, :string, unique: true
    field :type, CompanyTypeEnum

    has_many :owners, EstablishmentOwner
    has_many :employers, EstablishmentStaff

    timestamps()
    soft_delete_schema()
  end

  @required_fields ~w(name document_number type)a
  @optional_fields ~w()a

  @doc false
  def changeset(company, attrs) do
    IO.inspect(attrs)
    company
    |> cast(attrs, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
  end
end
