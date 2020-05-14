defmodule Fastpass.Operations.WorkingTimeGroup do
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.SoftDelete.Schema

  alias Fastpass.Establishments.Company
  alias Fastpass.Operations.WorkingTime

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "working_time_groups" do
    field :name, :string
    belongs_to(:company, Company)

    has_many(:working_times, WorkingTime)

    timestamps()
    soft_delete_schema()
  end

  @required_fields ~w(name company_id)a
  @optional_fields ~w()a

  @doc false
  def changeset(working_time_group, attrs) do
    working_time_group
    |> cast(attrs, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
  end
end
