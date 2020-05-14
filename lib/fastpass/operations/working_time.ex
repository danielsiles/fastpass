defmodule Fastpass.Operations.WorkingTime do
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.SoftDelete.Schema

  alias Fastpass.Operations.WorkingTimeGroup

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "working_times" do
    field :week_day, :integer
    field :open_time, :time
    field :close_time, :time
    belongs_to(:working_time_group, WorkingTimeGroup)
    timestamps()
    soft_delete_schema()
  end

  @required_fields ~w(working_time_group_id week_day open_time close_time)a
  @optional_fields ~w()a

  @doc false
  def changeset(working_time, attrs) do
    working_time
    |> cast(attrs, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
  end
end
