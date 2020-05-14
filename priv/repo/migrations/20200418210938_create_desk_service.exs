defmodule Fastpass.Repo.Migrations.CreateDeskService do
  use Ecto.Migration
  import Ecto.SoftDelete.Migration

  def change do
    create table(:desk_service, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :desk_id, references(:desks, type: :uuid), null: false
      add :service_id, references(:services, type: :uuid), null: false
      add :priority, :integer, default: 0
      timestamps()
      soft_delete_columns()
    end

    create unique_index(:desk_service, [:desk_id, :service_id])

  end
end
