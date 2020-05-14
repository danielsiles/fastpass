defmodule FastpassWeb.Schema.Establishments.EstablishmentMutations do
  use Absinthe.Schema.Notation

  alias FastpassWeb.Resolvers
  alias FastpassWeb.Middlewares.Authorize

  object :establishment_mutations do
    @desc "Create a new company"
    field :create_company, :company do
      arg(:input, non_null(:company_input))
      middleware(Authorize, :any)
      resolve(&Resolvers.EstablishmentResolver.create_company/3)
    end
  end

  input_object :company_input do
    field :name, :string |> non_null
    field :document_number, :string |> non_null
    field :type, :company_type_enum |> non_null
  end
end
