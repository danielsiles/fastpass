defmodule FastpassWeb.Schema.Accounts.UserMutations do
  use Absinthe.Schema.Notation

  alias FastpassWeb.Resolvers

  object :user_mutations do
    @desc "Register a new user"
    field :register_user, :user do
      arg(:input, non_null(:user_input))
      resolve(&Resolvers.UserResolver.register_user/3)
    end
  end
end
