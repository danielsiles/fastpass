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

  def check_in_booking(_, %{ticket_id: ticket_id}, %{context: %{current_user: user}}) do
    Tickets.check_in_booking(user, ticket_id)
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

  def booking(ticket, _, _) do
    {:ok, Tickets.get_booking_by_ticket(ticket.id)} |> IO.inspect
  end

  def latest_tickets(_, %{branch_id: branch_id}, _) do
    Tickets.latest_tickets(branch_id)
  end  

  def call_next_ticket(_, %{desk_id: desk_id, service_id: service_id}, %{context: %{current_user: user}}) do
    Tickets.call_next_ticket(desk_id, service_id, user)
  end  

  def call_next_ticket(_, %{desk_id: desk_id}, %{context: %{current_user: user}}) do
    Tickets.call_next_ticket(desk_id, user)
  end  

  def confirm_ticket(_, %{ticket_id: ticket_id}, %{context: %{current_user: user}}) do
    Tickets.confirm_ticket(ticket_id, user)
  end

  def recall_ticket(_, %{ticket_id: ticket_id}, %{context: %{current_user: user}}) do
    Tickets.recall_ticket(ticket_id, user)
  end

  def absent_ticket(_, %{ticket_id: ticket_id}, %{context: %{current_user: user}}) do
    Tickets.absent_ticket(ticket_id, user)
  end

  def cancel_ticket(_, %{ticket_id: ticket_id}, %{context: %{current_user: user}}) do
    Tickets.cancel_ticket(ticket_id, user)
  end

  def finalize_ticket(_, %{ticket_id: ticket_id}, %{context: %{current_user: user}}) do
    Tickets.finalize_ticket(ticket_id, user)
  end

  def transfer_ticket(_, %{ticket_id: ticket_id, service_id: service_id}, %{context: %{current_user: user}}) do
    Tickets.transfer_ticket(ticket_id, service_id, user)
  end

  def estimated_waiting_time(ticket, _, _) do
    Tickets.estimated_waiting_time(ticket)
  end

  def non_finished_tickets(_, %{desk_id: desk_id},  %{context: %{current_user: user}}) do
    Tickets.non_finished_tickets(user, desk_id)
  end

  def waiting_tickets(_, %{branch_id: branch_id},  %{context: %{current_user: user}}) do
    Tickets.waiting_tickets(user, branch_id )
  end

  def host_create_ticket(_, %{input: input}, %{context: %{current_user: user}}) do
    Tickets.host_create_ticket(user, input)
  end
end
