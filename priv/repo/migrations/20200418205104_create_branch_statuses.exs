defmodule Fastpass.Repo.Migrations.CreateBranchStatuses do
  use Ecto.Migration
  import Ecto.SoftDelete.Migration

  def change do
    create table(:branch_statuses, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :branch_id, references(:branches, type: :uuid), null: false
      add :status, :string, null: false
      timestamps()
      soft_delete_columns()
    end
  end
end
