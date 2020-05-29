defmodule Fastpass.Repo.Migrations.CreateCompanies do
  use Ecto.Migration
  import EctoEnum
  import Ecto.SoftDelete.Migration

  defenum CompanyTypeEnum, ["restaurant", "post_office", "bank"]

  def change do
    create table(:companies, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :name, :string, null: false
      add :document_number, :string, null: false
      add :type, CompanyTypeEnum.type(), null: false
      timestamps()
      soft_delete_columns()
    end

    create unique_index(:companies, [:document_number])

  end
end
