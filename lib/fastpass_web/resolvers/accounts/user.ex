defmodule FastpassWeb.Resolvers.UserResolver do
  alias Fastpass.Accounts
  alias Fastpass.Accounts.User

  def me(_, _, %{context: %{current_user: user}}) do
    {:ok, user}
  end

  def users(_, _, %{context: context}) do
    {:ok, Accounts.list_users()}
  end

  def register_user(_, %{input: input}, _) do
    Accounts.create_user(input)
  end
  
end
