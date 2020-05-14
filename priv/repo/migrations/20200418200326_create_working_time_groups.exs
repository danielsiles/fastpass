defmodule Fastpass.Repo.Migrations.CreateWorkingTimeGroups do
  use Ecto.Migration
  import Ecto.SoftDelete.Migration

  def change do
    create table(:working_time_groups, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :name, :string, null: false, null: false
      add :company_id, references(:companies, type: :uuid), null: false
      timestamps()
      soft_delete_columns()
    end

  end
end
