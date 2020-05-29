defmodule Fastpass.Repo.Migrations.CreateEstablishmentOwners do
  use Ecto.Migration
  import Ecto.SoftDelete.Migration

  def change do
    create table(:establishment_owners, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :user_id, references(:users, type: :uuid), null: false
      add :company_id, references(:companies, type: :uuid), null: false
      timestamps()
      soft_delete_columns()
    end

    create unique_index(:establishment_owners, [:user_id, :company_id])

  end
end
