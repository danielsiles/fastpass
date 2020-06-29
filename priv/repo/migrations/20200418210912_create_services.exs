defmodule Fastpass.Repo.Migrations.CreateServices do
  use Ecto.Migration
  import Ecto.SoftDelete.Migration

  import EctoEnum

  defenum ServiceStatusEnum, ["active", "inactive"]

  def change do
    create table(:services, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :name, :string, null: false
      add :service_letter, :string, null: false, null: false
      add :branch_id, references(:branches, type: :uuid), null: false
      add :working_time_group_id, references(:working_time_groups, type: :uuid)
      add :status, ServiceStatusEnum.type(), null: false
      timestamps()
      soft_delete_columns()
    end

    create unique_index(:services, [:branch_id, :service_letter])

  end
end
