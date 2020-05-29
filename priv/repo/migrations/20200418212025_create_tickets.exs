defmodule Fastpass.Repo.Migrations.CreateTickets do
  use Ecto.Migration
  import Ecto.SoftDelete.Migration
  import EctoEnum

  defenum BookingFromTypeEnum, ["web", "app", "host"]

  def change do
    create table(:tickets, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :service_id, references(:services, type: :uuid), null: false
      add :user_id, references(:users, type: :uuid), null: false
      add :is_fastpass, :boolean, default: false
      add :booking_from, BookingFromTypeEnum.type(), null: false
      add :waiting_time, :integer, default: 0
      add :serving_time, :integer, default: 0
      add :called_count, :integer, default: 0
      add :done_count, :integer, default: 0
      add :ticket_number, :string, null: false
      add :priority, :boolean, default: false
      timestamps()
      soft_delete_columns()
    end

  end
end
