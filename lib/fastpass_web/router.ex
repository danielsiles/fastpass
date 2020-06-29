defmodule FastpassWeb.Router do
  use FastpassWeb, :router

  pipeline :api do
    plug CORSPlug, origin: ["http://localhost:8081"]
    plug :accepts, ["json"]
    plug FastpassWeb.Plugs.Context
  end

  scope "/api" do
    pipe_through :api

    forward("/graphql", Absinthe.Plug, schema: FastpassWeb.Schema)

    # if Mix.env() == :dev do
      forward("/graphiql", Absinthe.Plug.GraphiQL,
      schema: FastpassWeb.Schema,
      interface: :advanced,
      socket: FastpassWeb.UserSocket)
    # end
  end
end
