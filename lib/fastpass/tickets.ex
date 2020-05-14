defmodule Fastpass.Tickets do
  @moduledoc """
  The Tickets context.
  """

  import Ecto.Query, warn: false
  alias Fastpass.Repo

  alias Fastpass.Tickets
  alias Fastpass.Tickets.{Ticket, Booking, TicketAction}
  alias Fastpass.Accounts.User
  alias Fastpass.Services
  alias Fastpass.Branches
  alias Fastpass.Services.Service

  @doc """
  Returns the list of tickets.

  ## Examples

      iex> list_tickets()
      [%Ticket{}, ...]

  """
  def list_tickets do
    Repo.all(Ticket)
  end

  @doc """
  Gets a single ticket.

  Raises `Ecto.NoResultsError` if the Ticket does not exist.

  ## Examples

      iex> get_ticket!(123)
      %Ticket{}

      iex> get_ticket!(456)
      ** (Ecto.NoResultsError)

  """
  def get_ticket!(id), do: Repo.get!(Ticket, id)

  @doc """
  Creates a ticket.

  ## Examples

      iex> create_ticket(%{field: value})
      {:ok, %Ticket{}}

      iex> create_ticket(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_ticket(attrs \\ %{}) do
    %Ticket{}
    |> Ticket.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a ticket.

  ## Examples

      iex> update_ticket(ticket, %{field: new_value})
      {:ok, %Ticket{}}

      iex> update_ticket(ticket, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_ticket(%Ticket{} = ticket, attrs) do
    ticket
    |> Ticket.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a ticket.

  ## Examples

      iex> delete_ticket(ticket)
      {:ok, %Ticket{}}

      iex> delete_ticket(ticket)
      {:error, %Ecto.Changeset{}}

  """
  def delete_ticket(%Ticket{} = ticket) do
    Repo.delete(ticket)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking ticket changes.

  ## Examples

      iex> change_ticket(ticket)
      %Ecto.Changeset{source: %Ticket{}}

  """
  def change_ticket(%Ticket{} = ticket) do
    Ticket.changeset(ticket, %{})
  end

  def get_next_fastpass_period(service_id, set \\ true) do
    today = to_string(Date.utc_today)
    now = Timex.local
    case Redix.command(:redix, ["GET", today <> ":" <> service_id <> ":fastpass"]) do # 2019-10-10:daidjda9-dawda-4daw3-dacvrndtw:fastpass
      {:ok, nil} ->
        new_period = %DateTime{year: now.year, month: now.month, day: now.day, zone_abbr: "CET",
          hour: now.hour, minute: 0, second: 0,
          utc_offset: 3600, std_offset: 0, time_zone: "America/Sao_Paulo"
        }
        |> DateTime.from_naive("Etc/UTC")
        {:ok, naive_new_period} = new_period
        new_start_period = DateTime.add(naive_new_period, (div(now.minute, 10) + 1) * 10 * 60, :second)
        new_end_period = DateTime.add(naive_new_period, (div(now.minute, 10) + 2) * 10 * 60, :second)
        if set do
          Redix.command(:redix, ["SET", today <> ":" <> service_id <> ":fastpass", to_string(new_end_period)])
        end
        {new_start_period, new_end_period}
      {:ok, last_period} ->
        {:ok, datetime, 0} = DateTime.from_iso8601(last_period)
        datetime |> IO.inspect
        last_period = 
        if DateTime.to_time(now) > datetime do
          DateTime.to_time(now)
        else
          datetime
        end
        
        new_period = %DateTime{year: last_period.year, month: last_period.month, day: last_period.day, zone_abbr: "CET",
          hour: last_period.hour, minute: 0, second: 0,
          utc_offset: 3600, std_offset: 0, time_zone: "America/Sao_Paulo"
        }
        |> DateTime.from_naive("Etc/UTC")
        {:ok, naive_new_period} = new_period
        new_start_period = DateTime.add(naive_new_period, (div(last_period.minute, 10)) * 10 * 60, :second)
        new_end_period = DateTime.add(naive_new_period, (div(last_period.minute, 10) + 1) * 10 * 60, :second)
        if set do
          Redix.command(:redix, ["SET", today <> ":" <> service_id <> ":fastpass", to_string(new_end_period)])
        end
        {new_start_period, new_end_period}
    end
  end

  def get_last_ticket_number(service) do
    today = to_string(Date.utc_today)
    case Redix.command(:redix, ["GET", today <> ":" <> service.id <> ":ticket_number"]) do
      {:ok, nil} ->
        new_ticket_number = service.service_letter <> "001"
        Redix.command(:redix, ["SET", today <> ":" <> service.id <> ":ticket_number", new_ticket_number])
        new_ticket_number
      {:ok, last_ticket_number} ->
        {num, _} = Integer.parse(String.slice(last_ticket_number, 1..3))
        num = "000" <> to_string(num + 1)
        len = String.length(num)
        new_ticket_number = service.service_letter <> String.slice(num, (len - 3)..len)
        Redix.command(:redix, ["SET", today <> ":" <> service.id <> ":ticket_number", new_ticket_number])
        new_ticket_number    
    end
  end

  def create_ticket(user, attrs) do 
    service = Services.get_service!(attrs.service_id)
    case Services.is_working(attrs.service_id) and Branches.is_working(service.branch_id) or true do # Checar se a branch esta funcionando tambem
      true ->
        result = Repo.transaction(fn ->
          ticket_number = Tickets.get_last_ticket_number(service)
          attrs = Map.put(attrs, :ticket_number, ticket_number)
          |> Map.put(:user_id, user.id)
          # Checar se o usuario já se encontra em uma fila
          try do
            %Ticket{}
            |> Ticket.changeset(attrs)
            |> Ecto.Changeset.put_assoc(:actions, [%TicketAction{
              status: :waiting,
              action: :book,
              actor: user
            }])
            |> Repo.insert()
          rescue
            x -> {:error, "You are already in a line"}
          end
        end)
        with({:ok, ticket} <- result) do
          ticket
        else
          _ -> {:error, "You are already in a line"}
        end
      false -> {:error, "This service is not working right now"}
      end
  end

  def create_booking(user, attrs) do 
    service = Services.get_service!(attrs.service_id)
    case Services.is_working(attrs.service_id) and Branches.is_working(service.branch_id) or true do
      true ->
        result = Repo.transaction(fn ->
          ticket_number = Tickets.get_last_ticket_number(service)
          attrs = Map.put(attrs, :ticket_number, ticket_number)
          |> Map.put(:user_id, user.id)
          |> Map.put(:is_fastpass, true)
          
          {minimum_arrival_time, maximum_arrival_time} = Tickets.get_next_fastpass_period(service.id)
        
          # Checar se o max_arrival_time é menor que o close_time do servico e branch

          booking_attrs = %{
            minimum_arrival_time: DateTime.to_naive(minimum_arrival_time),
            maximum_arrival_time: DateTime.to_naive(maximum_arrival_time)
          }
          try do # Trigger checa se o usuario já está em uma fila
            ticket = %Ticket{}
            |> Ticket.changeset(attrs)
            |> Ecto.Changeset.put_assoc(:booking, booking_attrs)
            |> Ecto.Changeset.put_assoc(:actions, [%TicketAction{
              status: :waiting,
              action: :book,
              actor: user
            }])
            |> Repo.insert()
          rescue
            x -> {:error, "You are already in a line"}
          end
        end)
        with({:ok, ticket} <- result) do
          ticket
        else
          _ -> {:error, "You are already in a line"}
        end
      false -> {:error, "This service is not working right now"}
      end
  end
end
