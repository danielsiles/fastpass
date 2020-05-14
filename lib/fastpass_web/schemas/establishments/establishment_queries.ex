defmodule FastpassWeb.Schema.Establishments.EstablishmentQueries do
  use Absinthe.Schema.Notation

  alias FastpassWeb.Resolvers

  object :establishment_queries do
    @desc "Get all establishments" # Paginate it later
    field :establishments, list_of(:company) do
      resolve(&Resolvers.EstablishmentResolver.list_establishments/3)
    end
  end
end
