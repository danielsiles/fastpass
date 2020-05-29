defmodule Fastpass.Repo.Migrations.CreateBookings do
  use Ecto.Migration
  import Ecto.SoftDelete.Migration

  def change do
    create table(:bookings, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :ticket_id, references(:tickets, type: :uuid), null: false
      add :minimum_arrival_time, :naive_datetime, null: false
      add :maximum_arrival_time, :naive_datetime, null: false
      timestamps()
      soft_delete_columns()
    end

  end
end
