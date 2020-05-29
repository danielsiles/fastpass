defmodule FastpassWeb.Schema.Accounts.SessionMutations do
  use Absinthe.Schema.Notation

  alias FastpassWeb.Resolvers

  object :session_mutations do
    @desc "Login a user and return a JWT token"
    field :login_user, :session do
      arg(:input, non_null(:session_input))
      resolve(&Resolvers.SessionResolver.login_user/3)
    end
  end
end
