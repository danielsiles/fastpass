# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Fastpass.Repo.insert!(%Fastpass.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

# Fastpass.Repo.insert!(%Fastpass.Accounts.User{}, %{first_name: "cliente1", last_name: "sobrenome", email: "cliente1@teste.com", password: "123456", cpf: "cliente1", phone_number: "21999999999"})