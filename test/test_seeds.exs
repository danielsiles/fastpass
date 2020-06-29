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
alias Fastpass.{Accounts, Establishments, Branches, Operations, Services}
alias Fastpass.Repo

defmodule Fastpass.Seeds.Helper do
  def create_user(name) do
    if !(user = Repo.get_by(Accounts.User, email: name <> "@test.com")) do
      Accounts.create_user(%{
        email: name <> "@test.com",
        password: "123456",
        first_name: name,
        last_name: "teste",
        phone_number: "21999765656",
        cpf: "331515151515" <> name
      })
    else
      {:ok, user}
    end
  end

  def create_company(user_id, name) do
    if !(company = Repo.get_by(Establishments.Company, name: name)) do
      Establishments.create_company(user_id, %{
        name: name,
        document_number: name <> "010101",
        type: :restaurant
      })
    else
      {:ok, company}
    end
  end

  def create_branch(user_id, company_id, name) do
    if !(branch = Repo.get_by(Branches.Branch, name: name)) do
      Branches.add_branch(user_id, %{
        city: "Rio de Janeiro",
        country: "Brasil",
        latitude: "-42.3523543",
        longitude: "-22.943281",
        name: name,
        neighborhood: "Jardim Botânico",
        company_id: company_id,
        state: "RJ",
        street: "Rua prudente de morais",
        number: "123"
      })
    else
      {:ok, branch}
    end
  end

  def create_service(user_id, branch_id, name, service_letter) do
    if !(service = Repo.get_by(Services.Service, name: name)) do
      Services.add_service(user_id, %{
        branch_id: branch_id,
        name: name,
        service_letter: service_letter
      })
    else
      {:ok, service}
    end
  end

  def create_working_time_group(user_id, company_id, name, working_times) do
    if !(working_time_group = Repo.get_by(Operations.WorkingTimeGroup, name: name)) do
      Operations.create_working_time_group(user_id, %{
        company_id: company_id,
        name: name,
        working_times: working_times
      })
    else
      {:ok, working_time_group}
    end
  end
  
end


alias Fastpass.Seeds.Helper

Helper.create_user("cliente1")
Helper.create_user("cliente2")
Helper.create_user("cliente3")
Helper.create_user("cliente4")
{:ok, client5} = Helper.create_user("cliente5")

{:ok, company1} = Helper.create_company(client5.id, "company1")
{:ok, branch1} = Helper.create_branch(client5.id, company1.id, "branch1")
Helper.create_branch(client5.id, company1.id, "branch2")
Helper.create_branch(client5.id, company1.id, "branch3")

{:ok, service1} = Helper.create_service(client5.id, branch1.id, "service1", "A")
{:ok, service2} = Helper.create_service(client5.id, branch1.id, "service2", "B")
Helper.create_service(client5.id, branch1.id, "service3", "C")

{:ok, workingTime} = Helper.create_working_time_group(client5.id, company1.id, "WorkingTime", [
  %{close_time: "23:59:59", open_time: "00:00:01", week_day: 0},
  %{close_time: "23:59:59", open_time: "00:00:01", week_day: 1},
  %{close_time: "23:59:59", open_time: "00:00:01", week_day: 2},
  %{close_time: "23:59:59", open_time: "00:00:01", week_day: 3},
  %{close_time: "23:59:59", open_time: "00:00:01", week_day: 4},
  %{close_time: "23:59:59", open_time: "00:00:01", week_day: 5},
  %{close_time: "23:59:59", open_time: "00:00:01", week_day: 6},
])
{:ok, notWorkingTime} = Helper.create_working_time_group(client5.id, company1.id, "NotWorkingTime", [])

Services.update_service(service1, %{working_time_group_id: workingTime.id})
Services.update_service(service2, %{working_time_group_id: notWorkingTime.id})

Branches.update_branch(branch1, %{working_time_group_id: workingTime.id})