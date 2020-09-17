defmodule Fastpass.Tickets do
  @moduledoc """
  The Tickets context.
  """

  import Ecto.Query, warn: false
  alias Fastpass.Repo

  alias Fastpass.Tickets
  alias Fastpass.Tickets.{Ticket, Booking, TicketAction, TicketTransfer}
  alias Fastpass.Accounts.User
  alias Fastpass.Services
  alias Fastpass.Branches
  alias Fastpass.Branches.Desk
  alias Fastpass.Services.{Service, DeskService}
  alias Fastpass.Accounts

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
  def get_ticket(id), do: Repo.get(Ticket, id)

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

  def get_branch_id(%Ticket{} = ticket) do
    query =
      from s in Service,
           where: s.id == ^ticket.service_id,
           select: s

    Repo.one(query).branch_id
  end

  def current_ticket(user) do
    query =
      from r in Ticket,
           where: r.user_id == ^user.id,
           where: r.status == ^:waiting or r.status == ^:called or r.status == ^:recalled,
           order_by: [
             desc: r.inserted_at
           ],
           limit: 1

    {:ok, Repo.one(query)}
  end

  def get_next_fastpass_period(service_id, set \\ true) do
    today = to_string(Date.utc_today())
    now = Timex.local()
    today = Timex.to_naive_datetime(Timex.today)
    query = from t in Ticket,
                 join: b in Booking,
                 on: b.ticket_id == t.id,
                 where: t.service_id == ^service_id,
                 where: t.is_fastpass == true,
                 where: t.inserted_at > ^today,
                 order_by: [
                   desc: t.inserted_at,
                   desc: t.ticket_number
                 ],
                 select: b.maximum_arrival_time,
                 limit: 1

    # case Redix.command(:redix, ["GET", today <> ":" <> service_id <> ":fastpass"]) do
    case Repo.one(query) do
      nil ->
        new_period =
          %DateTime{
            year: now.year,
            month: now.month,
            day: now.day,
            zone_abbr: "CET",
            hour: now.hour,
            minute: 0,
            second: 0,
            utc_offset: 3600,
            std_offset: 0,
            time_zone: "America/Sao_Paulo"
          }
          |> DateTime.from_naive("Etc/UTC")

        {:ok, naive_new_period} = new_period

        new_start_period =
          DateTime.add(naive_new_period, (div(now.minute, 10) + 1) * 10 * 60, :second)

        new_end_period =
          DateTime.add(naive_new_period, (div(now.minute, 10) + 2) * 10 * 60, :second)

        # if set do
        #   Redix.command(:redix, [
        #     "SET",
        #     today <> ":" <> service_id <> ":fastpass",
        #     to_string(new_end_period)
        #   ])
        # end

        {new_start_period, new_end_period}

      last_period ->
        # {:ok, datetime, 0} = DateTime.from_iso8601(last_period)
        {:ok, datetime} = DateTime.from_naive(last_period, "Etc/UTC")
        datetime
        |> IO.inspect()

        last_period =
          if DateTime.to_time(now) > datetime do
            DateTime.to_time(now)
          else
            datetime
          end

        new_period =
          %DateTime{
            year: last_period.year,
            month: last_period.month,
            day: last_period.day,
            zone_abbr: "CET",
            hour: last_period.hour,
            minute: 0,
            second: 0,
            utc_offset: 3600,
            std_offset: 0,
            time_zone: "America/Sao_Paulo"
          }
          |> DateTime.from_naive("Etc/UTC")

        {:ok, naive_new_period} = new_period

        new_start_period =
          DateTime.add(naive_new_period, div(last_period.minute, 10) * 10 * 60, :second)

        new_end_period =
          DateTime.add(naive_new_period, (div(last_period.minute, 10) + 1) * 10 * 60, :second)

        # if set do
        #   Redix.command(:redix, [
        #     "SET",
        #     today <> ":" <> service_id <> ":fastpass",
        #     to_string(new_end_period)
        #   ])
        # end

        {new_start_period, new_end_period}
    end
  end

  # def get_last_ticket_number(service) do
  #   today = to_string(Date.utc_today())

  #   case Redix.command(:redix, ["GET", today <> ":" <> service.id <> ":ticket_number"]) do
  #     {:ok, nil} ->
  #       new_ticket_number = service.service_letter <> "001"

  #       Redix.command(:redix, [
  #         "SET",
  #         today <> ":" <> service.id <> ":ticket_number",
  #         new_ticket_number
  #       ])

  #       new_ticket_number

  #     {:ok, last_ticket_number} ->
  #       {num, _} = Integer.parse(String.slice(last_ticket_number, 1..3))
  #       num = "000" <> to_string(num + 1)
  #       len = String.length(num)
  #       new_ticket_number = service.service_letter <> String.slice(num, (len - 3)..len)

  #       Redix.command(:redix, [
  #         "SET",
  #         today <> ":" <> service.id <> ":ticket_number",
  #         new_ticket_number
  #       ])

  #       new_ticket_number
  #   end
  # end

  def create_ticket(user, attrs) do
    service = Services.get_service(attrs.service_id)
    case (service != nil and Services.is_working(attrs.service_id) and Branches.is_working(service.branch_id)) do
      true ->
        result =
          Repo.transaction(
            fn ->
              attrs =
                Map.put(attrs, :user_id, user.id)
                |> Map.put(:status, :waiting)

              try do
                %Ticket{}
                |> Ticket.changeset(attrs)
                |> Ecto.Changeset.put_assoc(
                     :actions,
                     [
                       %TicketAction{
                         status: "waiting",
                         action: :book,
                         actor: user
                       }
                     ]
                   )
                |> Repo.insert()
              rescue
                _ -> {:error, "You are already in a line"}
              end

            end
          )

        with({:ok, ticket} <- result) do
          ticket
        else
          _ -> {:error, "You are already in a line"}
        end

      false ->
        {:error, "This service is not working right now"}
    end
  end

  def create_booking(user, attrs) do
    service = Services.get_service(attrs.service_id)

    case (service != nil and Services.is_working(attrs.service_id) and Branches.is_working(service.branch_id)) do
      true ->
        result =
          Repo.transaction(
            fn ->
              attrs =
                Map.put(attrs, :user_id, user.id)
                |> Map.put(:is_fastpass, true)
                |> Map.put(:status, :waiting)

              {minimum_arrival_time, maximum_arrival_time} =
                Tickets.get_next_fastpass_period(service.id)

              # Checar se o max_arrival_time é menor que o close_time do servico e branch
              booking_attrs = %{
                minimum_arrival_time: DateTime.to_naive(minimum_arrival_time),
                maximum_arrival_time: DateTime.to_naive(maximum_arrival_time)
              }

              try do
                ticket =
                  %Ticket{}
                  |> Ticket.changeset(attrs)
                  |> Ecto.Changeset.put_assoc(:booking, booking_attrs)
                  |> Ecto.Changeset.put_assoc(
                       :actions,
                       [
                         %TicketAction{
                           status: "waiting",
                           action: :book,
                           actor: user
                         }
                       ]
                     )
                  |> Repo.insert()
              rescue
                x -> {:error, "You are already in a line"}
              end
            end
          )

        with({:ok, ticket} <- result) do
          ticket
        else
          _ -> {:error, "You are already in a line"}
        end

      false ->
        {:error, "This service is not working right now"}
    end
  end

  def get_booking!(id), do: Repo.get!(Booking, id)
  def get_booking_by_ticket(ticket_id), do: Repo.get_by(Booking, ticket_id: ticket_id)

  def check_in_booking(user, ticket_id) do
    today = Timex.format!(Timex.local, "%FT%T%:z", :strftime)
    booking = Repo.get_by(Booking, ticket_id: ticket_id)

    {:ok, check_in} = NaiveDateTime.from_iso8601(today)
    check_in = NaiveDateTime.truncate(check_in, :second)

    if booking != nil do
      if booking.check_in != nil do
        {:error, "You have already checked in"}
      else
        if check_in > booking.minimum_arrival_time and check_in < booking.maximum_arrival_time do
          booking = Ecto.Changeset.change(booking, check_in: check_in)
          Repo.update(booking)
        else
          {:error, "Você não está no horario correto"}
        end
      end
    else
      {:error, "Invalid ticket"}
    end
  end

  def call_next_ticket(desk_id, actor) do
    query =
      from t in Ticket,
           join: s in Service,
           on: s.id == t.service_id,
           join: d in Desk,
           on: d.branch_id == s.branch_id,
           where: d.id == ^desk_id,
           where: t.status == ^:waiting,
           distinct: true,
           select: s.id

    waiting_tickets = Repo.all(query)
    desk_services =
      from ds in DeskService,
           where: ds.desk_id == ^desk_id,
           where: ds.service_id in ^waiting_tickets,
           select: ds

    services = Repo.all(desk_services)

    case length(services) > 0 do
      true ->
        random = Enum.random(1..1000) / 1000
        priority_sum = Enum.reduce(services, 0, fn x, acc -> x.priority + acc end)

        desk_service =
          Enum.reduce_while(
            services,
            priority_sum,
            fn x, acc ->
              if random < x.priority / acc do
                {:halt, x}
              else
                {:cont, acc - x.priority}
              end
            end
          )

        {:ok, result} =
          Repo.transaction(
            fn ->
              ticket = Tickets.get_next_waiting_ticket(desk_service.service_id)
              Tickets.call_ticket(ticket, actor)
            end
          )

        with({:ok, ticket} <- result) do
          {:ok, ticket}
        else
          _ -> {:error, "You do not have permission to call this ticket"}
        end

      false ->
        {:error, "The line is empty"}
    end
  end

  def call_next_ticket(desk_id, service_id, actor) do
    query =
      from t in Ticket,
           left_join: b in Booking,
           on: b.ticket_id == t.id,
           where: (t.is_fastpass == false or not is_nil(b.check_in)),
           where: t.service_id == ^service_id,
           where: t.status == ^:waiting,
           order_by: [
             asc: b.check_in,
             asc: t.inserted_at
           ],
           select: t,
           limit: 1

    waiting_ticket = Repo.one(query)

    case waiting_ticket do
      nil ->
        {:error, "There is not ticket for this service"}

      _ ->
        {:ok, result} =
          Repo.transaction(
            fn ->
              Tickets.call_ticket(waiting_ticket, actor)
            end
          )

        with({:ok, ticket} <- result) do
          {:ok, ticket}
        else
          _ -> {:error, "You do not have permission to call this ticket"}
        end
    end
  end

  def get_next_waiting_ticket(service_id) do
    query =
      from t in Ticket,
           left_join: b in Booking,
           on: b.ticket_id == t.id,
           where: (t.is_fastpass == false or not is_nil(b.check_in)),
           where: t.service_id == ^service_id,
           where: t.status == ^:waiting,
           order_by: [
             asc: b.check_in,
             asc: t.inserted_at
           ],
           select: t,
           limit: 1

    waiting_ticket = Repo.one(query)
  end

  def latest_tickets(branch_id) do
    query =
      from t in Ticket,
           left_join: s in Service,
           on: s.id == t.service_id,
           where: s.branch_id == ^branch_id,
           where: (t.status == ^:called or t.status == ^:recalled or t.status == ^:arrived),
           order_by: [
             desc: t.inserted_at
           ],
           select: t,
           limit: 10

    {:ok, Repo.all(query)}
  end

  def call_ticket(ticket, actor) do
    if !Tickets.is_user_staff(actor.id, ticket.id) do
      {:error, "Você não tem permissão para alterar o status deste ticket"}
    else
      %TicketAction{}
      |> TicketAction.changeset(
           %{
             ticket_id: ticket.id,
             status: "called",
             action: "call",
             actor_id: actor.id
           }
         )
      |> Repo.insert()

      ticket = Ecto.Changeset.change(ticket, status: :called)
      Repo.update(ticket)
      |> IO.inspect
    end
  end



  def get_status(ticket_id) do
    query =
      from ta in TicketAction,
           where: ta.ticket_id == ^ticket_id,
           order_by: [
             desc: :inserted_at
           ],
           select: ta,
           limit: 1

    Repo.one(query)
  end

  def estimated_waiting_time(ticket) do
    query =
      from t in Ticket,
           where: t.id != ^ticket.id,
           where: t.inserted_at < ^ticket.inserted_at,
           where: t.status == "waiting",
           select: count("*")

    [ticket_ahead] = Repo.all(query)

    # Número fixo, trocar por estatistica do restaurante
    {:ok, (ticket_ahead + 1) * 5}
  end

  def non_finished_tickets(user, desk_id) do
    with true <- Branches.is_user_owner(user.id, desk_id, :desk) do
      query =
        from t in Ticket,
             where: t.status == "called" or t.status == "recalled" or t.status == "arrived",
             order_by: [
               desc: t.inserted_at
             ],
             select: t

      {:ok, Repo.all(query)}
    else
      _ -> {:error, "Você não tem acesso aos tickets pendentes dessa desk"}
    end
  end

  def waiting_tickets(user, branch_id) do
    with true <- Branches.is_user_staff(user.id, branch_id, :branch) do
      query =
        from t in Ticket,
             where: t.status == "waiting",
             select: t

      {:ok, Repo.all(query)}
    else
      _ -> {:error, "Você não tem acesso aos tickets pendentes dessa filial"}
    end
  end

  def is_user_staff(user_id, ticket_id) do
    q = "SELECT TRUE FROM tickets as t, services as s, establishment_staffs as es where t.service_id = s.id and s.branch_id = es.branch_id and es.user_id = $1 and t.id = $2"
    {:ok, ticket} = Ecto.UUID.dump(ticket_id)
    {:ok, user} = Ecto.UUID.dump(user_id)
    with (%{rows: [[result]]} <- Ecto.Adapters.SQL.query!(Repo, q, [user, ticket])) do
      result
    else
      _ -> false
    end
  end

  def confirm_ticket(ticket_id, actor) do
    ticket = Tickets.get_ticket(ticket_id)
    if ticket != nil and !Tickets.is_user_staff(actor.id, ticket_id) do
      {:error, "Você não tem permissão para alterar o status deste ticket"}
    else
      case ticket.status do
        :no_show ->
          {:error, "O ticket não apareceu. Você não pode confirma-lo"}

        :canceled ->
          {:error, "O ticket já foi cancelado"}

        :done ->
          {:error, "O ticket já foi finalizado"}

        _ ->
          %TicketAction{}
          |> TicketAction.changeset(
               %{
                 ticket_id: ticket_id,
                 status: "arrived",
                 action: "confirm_arrival",
                 actor_id: actor.id
               }
             )
          |> Repo.insert()

          ticket = Ecto.Changeset.change(ticket, status: :arrived)
          Repo.update(ticket)
      end
    end
  end

  def absent_ticket(ticket_id, actor) do
    ticket = Tickets.get_ticket(ticket_id)
    if ticket != nil and !Tickets.is_user_staff(actor.id, ticket_id) do
      {:error, "Você não tem permissão para alterar o status deste ticket"}
    else
      case ticket.status do
        :arrived ->
          {:error, "O ticket já apareceu. Você não pode ausentá-lo"}

        :canceled ->
          {:error, "O ticket já foi cancelado"}

        :done ->
          {:error, "O ticket já foi finalizado"}

        _ ->
          %TicketAction{}
          |> TicketAction.changeset(
               %{
                 ticket_id: ticket_id,
                 status: "no_show",
                 action: "cancel",
                 actor_id: actor.id
               }
             )
          |> Repo.insert()

          ticket = Ecto.Changeset.change(ticket, status: :no_show)
          Repo.update(ticket)
      end
    end
  end

  def finalize_ticket(ticket_id, actor) do
    ticket = Tickets.get_ticket(ticket_id)
    if ticket != nil and !Tickets.is_user_staff(actor.id, ticket_id) do
      {:error, "Você não tem permissão para alterar o status deste ticket"}
    else
      case ticket.status do
        :no_show ->
          {:error, "O ticket não apareceu. Você não pode finaliza-lo"}

        :canceled ->
          {:error, "O ticket já foi cancelado"}

        :done ->
          {:error, "O ticket já foi finalizado"}

        _ ->
          %TicketAction{}
          |> TicketAction.changeset(
               %{
                 ticket_id: ticket_id,
                 status: "done",
                 action: "done",
                 actor_id: actor.id
               }
             )
          |> Repo.insert()

          ticket = Ecto.Changeset.change(ticket, status: :done)
          Repo.update(ticket)
      end
    end
  end

  def recall_ticket(ticket_id, actor) do
    ticket = Tickets.get_ticket(ticket_id)
    if ticket != nil and !Tickets.is_user_staff(actor.id, ticket_id) do
      {:error, "Você não tem permissão para alterar o status deste ticket"}
    else
      case ticket.status do
        :no_show ->
          {:error, "O ticket não apareceu. Você não pode rechama-lo"}

        :arrived ->
          {:error, "O ticket já apareceu"}

        :canceled ->
          {:error, "O ticket já foi cancelado"}

        :waiting ->
          {:error, "O ticket ainda não foi chamado"}

        :done ->
          {:error, "O ticket já foi finalizado"}

        _ ->
          %TicketAction{}
          |> TicketAction.changeset(
               %{
                 ticket_id: ticket_id,
                 status: "recalled",
                 action: "recall",
                 actor_id: actor.id
               }
             )
          |> Repo.insert()

          ticket = Ecto.Changeset.change(ticket, status: :recalled)
          Repo.update(ticket)
      end
    end
  end

  def cancel_ticket(ticket_id, actor) do
    ticket = Tickets.get_ticket(ticket_id)
    if ticket != nil and !Tickets.is_user_staff(actor.id, ticket_id) do
      {:error, "Você não tem permissão para alterar o status deste ticket"}
    else
      case ticket.status do
        :no_show ->
          {:error, "O ticket não apareceu. Você não pode rechama-lo"}

        :canceled ->
          {:error, "O ticket já foi cancelado"}

        :done ->
          {:error, "O ticket já foi finalizado"}

        _ ->
          %TicketAction{}
          |> TicketAction.changeset(
               %{
                 ticket_id: ticket_id,
                 status: "canceled",
                 action: "cancel",
                 actor_id: actor.id
               }
             )
          |> Repo.insert()

          ticket = Ecto.Changeset.change(ticket, status: :canceled)
          Repo.update(ticket)
      end
    end
  end

  def transfer_ticket(ticket_id, new_service_id, actor) do
    ticket = Tickets.get_ticket(ticket_id)
    if ticket != nil and !Tickets.is_user_staff(actor.id, ticket_id) do
      {:error, "Você não tem permissão para alterar o status deste ticket"}
    else
      case ticket.status do
        :no_show ->
          {:error, "O ticket não apareceu. Você não pode rechama-lo"}

        :canceled ->
          {:error, "O ticket já foi cancelado"}

        :done ->
          {:error, "O ticket já foi finalizado"}

        _ ->
          %TicketAction{}
          |> TicketAction.changeset(
               %{
                 ticket_id: ticket_id,
                 status: "waiting",
                 action: "transfer",
                 actor_id: actor.id
               }
             )
          |> Repo.insert()

          %TicketTransfer{}
          |> TicketTransfer.changeset(
               %{
                 ticket_id: ticket_id,
                 old_service_id: ticket.service_id,
                 new_service_id: new_service_id
               }
             )
          |> Repo.insert()

          ticket = Ecto.Changeset.change(ticket, status: :waiting, service_id: new_service_id)
          Repo.update(ticket)
      end
    end
  end

  def clean_no_show_tickets do
    q = "SELECT id FROM tickets where (status = 'recalled' or status = 'called') and EXTRACT(EPOCH FROM (now() - updated_at)) > 60 * 15"
    with (%{rows: tickets} <- Ecto.Adapters.SQL.query!(Repo, q, [])) do
      expired_tickets = Enum.map(
        tickets,
        fn x ->
          [ticket_id] = x
          {:ok, ticket_binary_id} = Ecto.UUID.load(ticket_id)
          ticket_binary_id
        end
      )

      Ticket
      |> where([t], t.id in ^expired_tickets)
      |> Repo.update_all(
           set: [
             status: :no_show
           ]
         )

      actions = Enum.map(
        expired_tickets,
        fn ticket_id ->
          %{
            ticket_id: ticket_id,
            status: "no_show",
            action: "cancel",
            actor_id: nil,
            inserted_at: NaiveDateTime.truncate(Timex.to_naive_datetime(Timex.local), :second),
            updated_at: NaiveDateTime.truncate(Timex.to_naive_datetime(Timex.local), :second)
          }
        end
      )
      Repo.insert_all(TicketAction, actions)
    else
      _ -> false
    end
  end

  def clean_waiting_tickets do
    q = "SELECT id FROM tickets where status = 'waiting' and EXTRACT(EPOCH FROM (now() - updated_at)) > 60 * 60 * 6"
    with (%{rows: tickets} <- Ecto.Adapters.SQL.query!(Repo, q, [])) do
      expired_tickets = Enum.map(
        tickets,
        fn x ->
          [ticket_id] = x
          {:ok, ticket_binary_id} = Ecto.UUID.load(ticket_id)
          ticket_binary_id
        end
      )

      Ticket
      |> where([t], t.id in ^expired_tickets)
      |> Repo.update_all(
           set: [
             status: :no_show
           ]
         )

      actions = Enum.map(
        expired_tickets,
        fn ticket_id ->
          %{
            ticket_id: ticket_id,
            status: "canceled",
            action: "cancel",
            actor_id: nil,
            inserted_at: NaiveDateTime.truncate(Timex.to_naive_datetime(Timex.local), :second),
            updated_at: NaiveDateTime.truncate(Timex.to_naive_datetime(Timex.local), :second)
          }
        end
      )
      Repo.insert_all(TicketAction, actions)
    else
      _ -> false
    end
  end

  def host_create_ticket(user, input) do
    case Branches.is_user_staff(user.id, input.service_id, :service) do
      true ->
        ticket_user = Accounts.get_user!(input.user_id)
        Tickets.create_ticket(
          ticket_user,
          %{
            booking_from: :host,
            priority: input.priority,
            service_id: input.service_id
          }
        )
      _ -> {:error, "Você não tem permissao para fazer isto"}
    end
  end

  def datasource() do
    Dataloader.Ecto.new(Repo, query: &query/2)
  end

  def query(queryable, _) do
    queryable
  end
end
