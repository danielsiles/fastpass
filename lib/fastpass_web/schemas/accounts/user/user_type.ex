defmodule FastpassWeb.Schema.Accounts.UserType do
  use Absinthe.Schema.Notation

  import Absinthe.Resolution.Helpers

  alias FastpassWeb.Resolvers
  alias Fastpass.Establishments

  object :user do
    field :id, :id
    field :first_name, :string
    field :last_name, :string
    field :email, :string
    field :cpf, :string
    field :device_token, :string
    field :phone_number, :string

    field :establishment_staff, :establishment_staff do
      resolve(&Resolvers.UserResolver.establishment_staff/3)
    end

    field :establishment_owner, :establishment_owner, resolve: dataloader(Establishments)

    field :tickets, list_of(:ticket |> non_null)

    field :current_ticket, :ticket do
      resolve(&Resolvers.TicketResolver.current_ticket/3)
    end

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
    field :phone_number, :string |> non_null
  end
end
