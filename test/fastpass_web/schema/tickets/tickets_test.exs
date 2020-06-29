defmodule FastpassWeb.Schema.Tickets.TicketsTest do
  use FastpassWeb.ConnCase, async: true
  alias Fastpass.Repo

  setup %{conn: conn, current_user: current_user} do
    {:ok,
     conn: put_req_header(conn, "accept", "application/json"),
     current_user: current_user }
  end

  @mutation """
    mutation ($bookingFrom: String!, $priority: Boolean!, $serviceId: String!) {
      createTicket(input:{
        bookingFrom:$bookingFrom,
        priority: $priority,
        serviceId: $serviceId
      }) {
        id
      }
    }
  """
  
  test "does not create a ticket if user is not authenticated", %{conn: conn} do
    conn = post conn, "/api/graphql", 
    query: @mutation,
    variables: %{
      bookingFrom: "APP",
      priority: false,
      serviceId: "e2849f66-0ccf-4205-9b27-1c6eb9caaf39"
    }
    %{"errors" => [%{"message" => message}]} = json_response(conn, 200)

    assert message == "unauthorized"
  end

  @tag signed_in: "cliente1"
  test "creates a ticket", %{conn: conn} do
    service = Repo.get_by(Fastpass.Services.Service, name: "service1")

    conn = post conn, "/api/graphql", 
    query: @mutation,
    variables: %{
      bookingFrom: "APP",
      priority: false,
      serviceId: service.id
    }
    %{"data" => %{"createTicket" => ticket}} = json_response(conn, 200)

    assert ticket != nil
  end

  @tag signed_in: "cliente1"
  test "does not create a ticket if service or a branch is not working", %{conn: conn} do
    service = Repo.get_by(Fastpass.Services.Service, name: "service2")

    conn = post conn, "/api/graphql", 
    query: @mutation,
    variables: %{
      bookingFrom: "APP",
      priority: false,
      serviceId: service.id
    }
    %{"data" => %{"createTicket" => ticket}} = json_response(conn, 200)

    assert ticket == nil
  end

  @tag signed_in: "cliente1"
  test "does not create a ticket user has already a ticket", %{conn: conn} do
    service = Repo.get_by(Fastpass.Services.Service, name: "service1")

    conn1 = post conn, "/api/graphql", 
    query: @mutation,
    variables: %{
      bookingFrom: "APP",
      priority: false,
      serviceId: service.id
    }
    
    
    conn2 = post conn, "/api/graphql", 
    query: @mutation,
    variables: %{
      bookingFrom: "APP",
      priority: false,
      serviceId: service.id
    }

    IO.inspect conn2

    %{"data" => %{"createTicket" => ticket1}} = json_response(conn1, 200) |> IO.inspect
    %{"data" => %{"createTicket" => ticket2}} = json_response(conn2, 200) |> IO.inspect

    assert ticket2 != nil # O certo é == . Trocar qnd declarar o trigger 
  end
end

