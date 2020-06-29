defmodule FastpassWeb.Schema.Establishments.EstablishmentTypes do
    use Absinthe.Schema.Notation

    import Absinthe.Resolution.Helpers
  
    alias FastpassWeb.Resolvers
    alias Fastpass.{Establishments,Branches}

    enum :company_type_enum do
      value :restaurant
      value :post_office
      value :bank
    end
  
    object :company do
      field :id, :id
      field :name, :string
      field :document_number, :string
      field :type, :company_type_enum
      field :branches, list_of(:branch |> non_null) |> non_null, resolve: dataloader(Branches)
      field :owners, list_of(:establishment_owner |> non_null) |> non_null
      
      field :inserted_at, :naive_datetime
      field :updated_at, :naive_datetime
      field :deleted_at, :naive_datetime
    end

    object :establishment_owner do
      field :id, :id
      field :company, :company, resolve: dataloader(Establishments)
      field :user, :user

      field :inserted_at, :naive_datetime
      field :updated_at, :naive_datetime
      field :deleted_at, :naive_datetime
    end

    object :establishment_staff do
      field :id, :id
      field :user, :user
      field :branch, :branch do
        resolve(&Resolvers.EstablishmentResolver.branch/3)
      end
      field :role, :string
      
      field :ticket_actions, list_of(:ticket_action |> non_null)

      field :inserted_at, :naive_datetime
      field :updated_at, :naive_datetime
      field :deleted_at, :naive_datetime
    end
  
    
  end
  