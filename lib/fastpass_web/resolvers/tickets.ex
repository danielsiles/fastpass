defmodule FastpassWeb.Resolvers.TicketResolver do
  alias Fastpass.Tickets
  alias Fastpass.Services
  # alias Fastpass.Establishments.Company

  def create_ticket(_, %{input: input}, %{context: %{current_user: user}}) do
    Tickets.create_ticket(user, input)
  end

  def create_booking(_, %{input: input}, %{context: %{current_user: user}}) do
    Tickets.create_booking(user, input)
  end

  def current_ticket(_, _, %{context: %{current_user: user}}) do
    Tickets.current_ticket(user)
  end  

  def current_ticket(user, _, _) do
    Tickets.current_ticket(user)
  end  
  
  def status(ticket, _, _) do
    {:ok, Tickets.get_status(ticket.id)}
  end  

  def service(ticket, _, _) do
    {:ok, Services.get_service!(ticket.service_id)}
  end

  def call_next_ticket(_, %{desk_id: desk_id}, %{context: %{current_user: user}}) do
    Tickets.call_next_ticket(desk_id, user)
  end  

  def recall_ticket(_, %{ticket_id: ticket_id}, %{context: %{current_user: user}}) do
    Tickets.recall_ticket(ticket_id, user)
  end

  def cancel_ticket(_, %{ticket_id: ticket_id}, %{context: %{current_user: user}}) do
    Tickets.cancel_ticket(ticket_id, user)
  end

  def estimated_waiting_time(ticket, _, _) do
    Tickets.estimated_waiting_time(ticket)
  end

end
