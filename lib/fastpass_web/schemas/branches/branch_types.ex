defmodule FastpassWeb.Schema.Branches.BranchTypes do
    use Absinthe.Schema.Notation

    import Absinthe.Resolution.Helpers
  
    alias Fastpass.Services
    alias Fastpass.Branches
    alias Fastpass.Establishments
    alias FastpassWeb.Resolvers
  
    object :branch do
      field :id, :id
      field :name, :string
      field :latitude, :string
      field :longitude, :string
      field :address, :string
      field :neighborhood, :string

      field :company, :company, resolve: dataloader(Establishments, :company)

      field :working_time_group, :working_time_group
      field :statuses, list_of(:branch_status |> non_null) |> non_null, resolve: dataloader(Branches)
      field :desks, list_of(:desk |> non_null) |> non_null do
        resolve(&Resolvers.BranchResolver.desks/3)
      end
      field :establishment_staffs, list_of(:establishment_staff |> non_null) |> non_null
    
      # Dataloader
      field :services, list_of(:service |> non_null) |> non_null, resolve: dataloader(Services)
      
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
  