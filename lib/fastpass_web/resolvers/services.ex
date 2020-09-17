defmodule FastpassWeb.Resolvers.ServiceResolver do
  alias Fastpass.Services
  alias Fastpass.Branches

  def add_service(_, %{input: input}, %{context: %{current_user: user}}) do
    
    Services.add_service(user.id, input)
  end

  def set_desk_service(_, %{input: input}, %{context: %{current_user: user}}) do
    Services.set_desk_service(user.id, input)
  end

  def working_services(_, %{branch_id: branch_id}, _) do
    {:ok, Services.list_working_services(branch_id)}
  end

  def next_fastpass_period(_, %{service_id: service_id}, _) do
    Services.next_fastpass_period(service_id)
  end

  def next_fastpass_period(service, _, _) do
    Services.next_fastpass_period(service.id)
  end

  def waiting_time(service, _, _) do
    Services.waiting_time(service.id)
  end

  def branch(service, _, _) do
    {:ok, Branches.get_branch!(service.branch_id)}
  end
  
end
