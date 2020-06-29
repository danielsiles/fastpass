defmodule FastpassWeb.Middlewares.ErrorHandler do
  @behaviour Absinthe.Middleware
  alias Fastpass.EctoHelpers

  def call(resolution, _config) do
    errors =
      resolution
      |> Map.get(:errors)
      |> Enum.flat_map(&process_errors/1)
      
    resolution |> Absinthe.Resolution.put_result({:error, errors})
  end

  defp process_errors(%Ecto.Changeset{} = changeset) do
    EctoHelpers.process_errors(changeset)
  end

  defp process_errors(error), do: [error]
end