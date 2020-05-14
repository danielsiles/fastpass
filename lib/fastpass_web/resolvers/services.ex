defmodule FastpassWeb.Resolvers.ServiceResolver do
  alias Fastpass.Services
  # alias Fastpass.Establishments.Company

  def add_service(_, %{input: input}, %{context: %{current_user: user}}) do
    Services.add_service(user.id, input)
  end

  def set_desk_service(_, %{input: input}, %{context: %{current_user: user}}) do
    Services.set_desk_service(user.id, input)
  end

  def working_services(_, _, _) do
    {:ok, Services.list_working_services}
  end

  def next_fastpass_period(_, %{service_id: service_id}, _) do
    Services.next_fastpass_period(service_id)
  end
  
end
