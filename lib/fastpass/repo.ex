defmodule Fastpass.Repo do
  use Ecto.Repo,
    otp_app: :fastpass,
    adapter: Ecto.Adapters.Postgres

  # def init(_, config) do
  #   config = config
  #     |> Keyword.put(:username, System.get_env("PGUSER"))
  #     |> Keyword.put(:password, System.get_env("PGPASSWORD"))
  #     |> Keyword.put(:database, System.get_env("PGDATABASE"))
  #     |> Keyword.put(:hostname, System.get_env("PGHOST"))
  #     |> Keyword.put(:port, System.get_env("PGPORT") |> String.to_integer)
  #   {:ok, config}
  # end

  defoverridable [get: 2, get: 3]
    def get(query, id, opts \\ []) do
      super(query, id, opts)
    rescue
      Ecto.Query.CastError -> nil
  end
end

