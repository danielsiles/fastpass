defmodule FastpassWeb.Schema.Accounts.UserType do
  use Absinthe.Schema.Notation

  alias FastpassWeb.Resolvers

  object :user do
    field :id, :id
    field :first_name, :string
    field :last_name, :string
    field :email, :string
    field :cpf, :string
    field :device_token, :string
    
    field :establishment_staff, :establishment_staff
    field :establishment_owner, :establishment_owner

    field :tickets, list_of(:ticket |> non_null)
    
    field :inserted_at, :naive_datetime
    field :updated_at, :naive_datetime
    field :deleted_at, :naive_datetime
  end

  input_object :user_input do
    field :first_name, :string |> non_null
    field :last_name, :string |> non_null
    field :email, :string |> non_null
    field :password, :string |> non_null
    field :cpf, :string |> non_null
  end
end
