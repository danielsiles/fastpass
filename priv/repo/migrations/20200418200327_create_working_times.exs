defmodule Fastpass.Repo.Migrations.CreateWorkingTimes do
  use Ecto.Migration
  import Ecto.SoftDelete.Migration

  def change do
    create table(:working_times, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :working_time_group_id, references(:working_time_groups, type: :uuid), null: false
      add :week_day, :integer, null: false
      add :open_time, :time, null: false
      add :close_time, :time, null: false
      timestamps()
      soft_delete_columns()
    end

    create unique_index(:working_times, [:working_time_group_id, :week_day])
  end
end
