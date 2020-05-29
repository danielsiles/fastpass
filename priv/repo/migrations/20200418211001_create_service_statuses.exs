defmodule Fastpass.Repo.Migrations.CreateServiceStatuses do
  use Ecto.Migration
  import Ecto.SoftDelete.Migration
  import EctoEnum

  defenum ServiceStatusEnum, ["active", "inactive"]

  def change do
    create table(:service_statuses, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :service_id, references(:services, type: :uuid), null: false
      add :status, ServiceStatusEnum.type(), null: false
      timestamps()
      soft_delete_columns()
    end

  end
end
