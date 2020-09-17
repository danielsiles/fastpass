defmodule FastpassWeb.Resolvers.UserResolver do
  alias Fastpass.Accounts
  alias Fastpass.Accounts.User
  alias Fastpass.EctoHelpers

  def me(
        _,
        _,
        %{
          context: %{
            current_user: user
          }
        }
      ) do
    {:ok, user}
  end

  def users(_, _, %{context: context}) do
    {:ok, Accounts.list_users()}
  end

  def register_user(_, %{input: input}, _) do
    Accounts.create_user(input)
  end

  def get_user_by_cpf(_, %{cpf: cpf}, _) do
    Accounts.get_user_by_cpf(cpf)
  end

  def establishment_staff(user, _, _) do
    {:ok, Accounts.establishment_staff(user)}
  end
end
