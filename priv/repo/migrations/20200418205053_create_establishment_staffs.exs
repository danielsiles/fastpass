defmodule Fastpass.Repo.Migrations.CreateEstablishmentStaffs do
  use Ecto.Migration
  import Ecto.SoftDelete.Migration

  def change do
    create table(:establishment_staffs, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :user_id, references(:users, type: :uuid), null: false
      add :branch_id, references(:branches, type: :uuid), null: false
      add :role, :string
      timestamps()
      soft_delete_columns()
    end

    create unique_index(:establishment_staffs, [:user_id, :branch_id])

  end
end
