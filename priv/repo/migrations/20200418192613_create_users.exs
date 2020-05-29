defmodule Fastpass.Repo.Migrations.CreateUsers do
  use Ecto.Migration
  

  def change do
    create table(:users, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :first_name, :string, null: false
      add :last_name, :string, null: false
      add :email, :string, unique: true, null: false
      add :password_hash, :string, null: false
      add :device_token, :string
      add :cpf, :string, null: false
      timestamps()
    end

    create unique_index(:users, [:email])
    create unique_index(:users, [:cpf])

  end
end
