defmodule Fastpass.Repo.Migrations.AddCheckedInToBookingTable do
  use Ecto.Migration

  def change do
    alter table("bookings") do
      add :check_in, :naive_datetime, default: nil
    end
  end
end
