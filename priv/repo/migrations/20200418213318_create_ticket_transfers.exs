defmodule Fastpass.Repo.Migrations.CreateTicketTransfers do
  use Ecto.Migration
  import Ecto.SoftDelete.Migration
  import EctoEnum

  defenum TransferTypeEnum, ["first", "last"]

  def change do
    create table(:ticket_transfers, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :old_service_id, references(:services, type: :uuid), null: false
      add :new_service_id, references(:services, type: :uuid), null: false
      add :old_user_id, references(:users, type: :uuid), null: false
      add :new_user_id, references(:users, type: :uuid), null: false
      add :ticket_id, references(:tickets, type: :uuid), null: false
      add :type, TransferTypeEnum.type(), null: false
      timestamps()
      soft_delete_columns()
    end

  end
end
