defmodule FastpassWeb.Schema.Accounts.UserQueries do
  use Absinthe.Schema.Notation

  alias FastpassWeb.Resolvers
  alias FastpassWeb.Middlewares.Authorize

  object :user_queries do
    @desc "Get the currently signed-in user"
    field :me, :user do
      middleware(Authorize, :any)
      resolve(&Resolvers.UserResolver.me/3)
    end

    @desc "Get a list of all users"
    field :users, list_of(:user) do
      middleware(Authorize, :any)
      resolve(&Resolvers.UserResolver.users/3)
    end

    @desc "Get user by cpf"
    field :get_user_by_cpf, :user do
      arg(:cpf, non_null(:string))
      middleware(Authorize, :any)
      resolve(&Resolvers.UserResolver.get_user_by_cpf/3)
    end
  end
end
