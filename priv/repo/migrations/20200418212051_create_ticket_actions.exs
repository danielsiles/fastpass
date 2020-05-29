defmodule Fastpass.Repo.Migrations.CreateTicketActions do
  use Ecto.Migration
  import Ecto.SoftDelete.Migration
  import EctoEnum

  defenum TicketStatusEnum, ["waiting", "done", "canceled", "no_show", "called", "recalled", "arrived"]
  defenum TicketActionTypeEnum, ["book", "call", "recall", "transfer", "done", "cancel", "confirm_arrival"]

  def change do
    create table(:ticket_actions, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :ticket_id, references(:tickets, type: :uuid), null: false
      add :status, TicketStatusEnum.type(), null: false
      add :action, TicketActionTypeEnum.type(), null: false
      add :actor, references(:establishment_staffs, type: :uuid), null: false
      timestamps()
      soft_delete_columns()
    end

  end
end
