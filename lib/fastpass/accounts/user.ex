defmodule Fastpass.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset

  alias Fastpass.Establishments.EstablishmentOwner

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "users" do
    field :first_name, :string
    field :last_name, :string
    field :email, :string, unique: true
    field :password_hash, :string
    field :password, :string, virtual: true
    field :device_token, :string
    field :cpf, :string, unique: true
    field :phone_number, :string
    has_one(:establishment_owner, EstablishmentOwner)
    timestamps()
  end
  
  @required_fields ~w(first_name last_name email password cpf phone_number)a
  @optional_fields ~w(device_token)a

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
    |> validate_format(:email, ~r/@/)
    |> update_change(:email, &String.downcase(&1))
    |> validate_length(:password, min: 6, max: 100)
    |> unique_constraint(:email)
    |> unique_constraint(:cpf)
    |> hash_password
    # |> handle_errors
  end

  defp hash_password(%Ecto.Changeset{valid?: true, changes: %{password: password}} = changeset) do
    change(changeset, Argon2.add_hash(password))
  end

  defp hash_password(changeset) do
    changeset
  end

  # defp handle_errors(%Ecto.Changeset{valid?: false} = changeset) do
  #   Ecto.Changeset.traverse_errors(fn {msg, _} -> msg end) |> IO.inspect
  # end

  # defp handle_errors(changeset) do
  #   changeset
  # end
end
