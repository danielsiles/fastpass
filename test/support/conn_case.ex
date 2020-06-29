defmodule FastpassWeb.ConnCase do
  @moduledoc """
  This module defines the test case to be used by
  tests that require setting up a connection.

  Such tests rely on `Phoenix.ConnTest` and also
  import other functionality to make it easier
  to build common data structures and query the data layer.

  Finally, if the test case interacts with the database,
  we enable the SQL sandbox, so changes done to the database
  are reverted at the end of every test. If you are using
  PostgreSQL, you can even run database tests asynchronously
  by setting `use FastpassWeb.ConnCase, async: true`, although
  this option is not recommended for other databases.
  """

  use ExUnit.CaseTemplate

  alias Fastpass.Accounts
  alias FastpassWeb.Resolvers.SessionResolver

  using do
    quote do
      # Import conveniences for testing with connections
      use Phoenix.ConnTest
      alias FastpassWeb.Router.Helpers, as: Routes

      # The default endpoint for testing
      @endpoint FastpassWeb.Endpoint
    end
  end

  def create_user(name) do
    Accounts.create_user(%{
      email: name <> "@test.com",
      password: "123456",
      first_name: "teste",
      last_name: "teste",
      phone_number: "21999765656",
      cpf: "331515151515" <> name
    })
  end

  def create_session(name) do
    SessionResolver.login_user(%{}, %{input: %{
      email: name <> "@test.com",
      password: "123456"
  }},%{})
  end

  setup tags do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(Fastpass.Repo)

    unless tags[:async] do
      Ecto.Adapters.SQL.Sandbox.mode(Fastpass.Repo, {:shared, self()})
    end
    conn = Phoenix.ConnTest.build_conn()
    if tags[:signed_in] do
      # user = create_user(tags[:signed_in]) |> IO.inspect
      {:ok, %{token: token, user: user}} = create_session(tags[:signed_in])
      conn = Plug.Conn.put_req_header(conn,
               "authorization", "Bearer " <> token)

      {:ok, conn: conn, current_user: user}
    else
      {:ok, conn: conn, current_user: nil}
    end
    # {:ok, conn: Phoenix.ConnTest.build_conn()}
  end
end
