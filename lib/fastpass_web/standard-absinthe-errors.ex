defmodule FastpassWeb.Schema.Errors do
  @moduledoc """
  Defines common GraphQL error responses
  """
  defmacro __using__(_) do
    quote do
      @permission_denied {
        :error,
        %{
          message: "Permission denied",
          code: :permission_denied
        }
      }

      @not_found {
        :error,
        %{
          code: :not_found,
          message: "Not found"
        }
      }

      @not_authenticated {
        :error,
        %{
          code: :not_authenticated,
          message: "Not authenticated"
        }
      }
    end
  end
end