defmodule Fastpass.Repo.Migrations.AddPhoneNumberToUsersTable do
  use Ecto.Migration

  def change do
    alter table("users") do
      add :phone_number, :string, null: false
    end
  end
end
