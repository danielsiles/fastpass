defmodule FastpassWeb.Schema.Services.ServiceTypes do
    use Absinthe.Schema.Notation
  
    alias FastpassWeb.Resolvers

    object :service do
      field :id, :id
      field :name, :string
      field :service_letter, :string
      field :branch, :branch
      field :working_time_group, :working_time_group
      field :status, list_of(:service_status |> non_null) |> non_null
      field :desk_services, list_of(:desk_service |> non_null) |> non_null

      field :tickets, list_of(:ticket |> non_null)


      field :inserted_at, :naive_datetime
      field :updated_at, :naive_datetime
      field :deleted_at, :naive_datetime
    end

    enum :service_status_enum do
      value :active
      value :inactive
    end

    object :service_status do
      field :id, :id
      field :service, :service
      field :status, :service_status_enum

      field :inserted_at, :naive_datetime
      field :updated_at, :naive_datetime
      field :deleted_at, :naive_datetime
    end

    object :desk_service do
      field :id, :id
      field :service, :service
      field :desk, :desk
      field :priority, :integer

      field :inserted_at, :naive_datetime
      field :updated_at, :naive_datetime
      field :deleted_at, :naive_datetime
    end
  end
  