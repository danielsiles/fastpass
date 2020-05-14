defmodule FastpassWeb.Resolvers.TicketResolver do
  alias Fastpass.Tickets
  # alias Fastpass.Establishments.Company

  def create_ticket(_, %{input: input}, %{context: %{current_user: user}}) do
    Tickets.create_ticket(user, input)
  end

  def create_booking(_, %{input: input}, %{context: %{current_user: user}}) do
    Tickets.create_booking(user, input)
  end
  
end
