defmodule FastpassWeb.Schema.Establishments.EstablishmentTypes do
    use Absinthe.Schema.Notation
  
    alias FastpassWeb.Resolvers

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
      field :branches, list_of(:branch |> non_null) |> non_null
      field :owners, list_of(:establishment_owner |> non_null) |> non_null
      
      field :inserted_at, :naive_datetime
      field :updated_at, :naive_datetime
      field :deleted_at, :naive_datetime
    end

    object :establishment_owner do
      field :id, :id
      field :company, :company
      field :user, :user

      field :inserted_at, :naive_datetime
      field :updated_at, :naive_datetime
      field :deleted_at, :naive_datetime
    end

    object :establishment_staff do
      field :id, :id
      field :user, :user
      field :branch, :branch
      field :role, :string
      
      field :ticket_actions, list_of(:ticket_action |> non_null)

      field :inserted_at, :naive_datetime
      field :updated_at, :naive_datetime
      field :deleted_at, :naive_datetime
    end
  
    
  end
  