defmodule FastpassWeb.Schema.Branches.BranchTypes do
    use Absinthe.Schema.Notation
  
    alias FastpassWeb.Resolvers
  
    object :branch do
      field :id, :id
      field :name, :string
      field :latitude, :string
      field :longitude, :string
      field :address, :string

      field :company, :company
      field :working_time_group, :working_time_group
      field :statuses, list_of(:branch_status |> non_null) |> non_null
      field :desks, list_of(:desk |> non_null) |> non_null
      field :establishment_staffs, list_of(:establishment_staff |> non_null) |> non_null
      field :services, list_of(:service |> non_null) |> non_null
      
      field :inserted_at, :naive_datetime
      field :updated_at, :naive_datetime
      field :deleted_at, :naive_datetime
    end

    enum :branch_status_enum do
      value :active
      value :inactive
    end

    object :branch_status do
      field :id, :id
      field :branch, :branch
      field :status, :branch_status_enum
      
      field :inserted_at, :naive_datetime
      field :updated_at, :naive_datetime
      field :deleted_at, :naive_datetime
    end

    object :desk do
      field :id, :id
      field :branch, :branch
      field :name, :string

      field :desk_services, list_of(:desk_service |> non_null) |> non_null
      
      field :inserted_at, :naive_datetime
      field :updated_at, :naive_datetime
      field :deleted_at, :naive_datetime
    end
  end
  