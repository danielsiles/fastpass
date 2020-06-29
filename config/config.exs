# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :fastpass,
  ecto_repos: [Fastpass.Repo],
  generators: [binary_id: true]

# Configures the endpoint
config :fastpass, FastpassWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "IQhdjIvhVD48AwCoY3FmyPKem+XHootUTcqDVu+drsd7oFncG52Uo2KHNui4oyG2",
  render_errors: [view: FastpassWeb.ErrorView, accepts: ~w(json)],
  pubsub: [name: Fastpass.PubSub, adapter: Phoenix.PubSub.PG2],
  live_view: [signing_salt: "du0QN2pO"]

# # PubSub config
# config :fastpass, FastpassWeb.Endpoint,
#   # ... other config
#   pubsub: [name: FastpassWeb.PubSub,
#            adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Guardian config details
config :fastpass, Fastpass.Guardian,
  issuer: "fastpass",
  secret_key: "fHvAh3ECTFc29dabodvX1vTwJRThDAZosABPUN1SAyS6Kol6Q7Eyh84AFNdoPzA/"

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"

# config :fastpass, Fastpass.Scheduler,
#   jobs: [
#     # Every minute
#     {"* * * * *",      fn -> Fastpass.Tickets.clean_no_show_tickets end},
#     {"* * * * *",      fn -> Fastpass.Tickets.clean_waiting_tickets end}
#   ]