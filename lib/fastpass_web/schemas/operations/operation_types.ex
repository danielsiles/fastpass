defmodule FastpassWeb.Schema.Operations.OperationTypes do
    use Absinthe.Schema.Notation
  
    import Absinthe.Resolution.Helpers

    alias FastpassWeb.Resolvers
    alias Fastpass.Operations

    object :working_time_group do
      field :id, :id
      field :name, :string
      field :company, :company

      field :branches, list_of(:branch |> non_null)
      field :services, list_of(:service |> non_null)
      field :working_times, list_of(:working_time |> non_null), resolve: dataloader(Operations)

      field :inserted_at, :naive_datetime
      field :updated_at, :naive_datetime
      field :deleted_at, :naive_datetime
    end

    object :working_time do
      field :id, :id
      field :week_day, :integer
      field :open_time, :time
      field :close_time, :time
      field :working_time_group, :working_time_group

      field :inserted_at, :naive_datetime
      field :updated_at, :naive_datetime
      field :deleted_at, :naive_datetime
    end
  end
  