defmodule Fastpass.Repo.Migrations.CreateDesks do
  use Ecto.Migration
  import Ecto.SoftDelete.Migration

  def change do
    create table(:desks, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :branch_id, references(:branches, type: :uuid), null: false
      add :name, :string, null: false
      timestamps()
      soft_delete_columns()
    end

    create unique_index(:desks, [:branch_id, :name])
  end
end
