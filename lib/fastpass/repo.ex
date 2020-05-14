defmodule Fastpass.Repo do
  use Ecto.Repo,
    otp_app: :fastpass,
    adapter: Ecto.Adapters.Postgres
end
