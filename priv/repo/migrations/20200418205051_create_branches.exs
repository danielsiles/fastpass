defmodule Fastpass.Repo.Migrations.CreateBranches do
  use Ecto.Migration
  import Ecto.SoftDelete.Migration

  import EctoEnum

  defenum BranchStatusEnum, ["active", "inactive"]

  def change do
    create table(:branches, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :company_id, references(:companies, type: :uuid), null: false
      add :name, :string, null: false
      add :latitude, :string, null: false
      add :longitude, :string, null: false
      add :country, :string, null: false
      add :state, :string, null: false
      add :city, :string, null: false
      add :neighborhood, :string, null: false
      add :street, :string, null: false
      add :number, :string, null: false
      add :complement, :string
      add :working_time_group_id, references(:working_time_groups, type: :uuid)
      add :status, BranchStatusEnum.type(), null: false
      timestamps()
      soft_delete_columns()
    end

  end
end
