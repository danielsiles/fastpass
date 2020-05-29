defmodule FastpassWeb.Schema.Accounts.SessionType do
  use Absinthe.Schema.Notation

  object :session do
    field :token, :string
    field :user, :user
  end

  input_object :session_input do
    field :email, :string |> non_null
    field :password, :string |> non_null
  end
end
