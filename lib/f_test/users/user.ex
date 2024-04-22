defmodule FTest.Users.User do
  use Ecto.Schema
  import Ecto.Changeset
  alias FTest.Repo

  schema "users" do
    field :username, :string
    field :email, :string
    field :phone, :string
    field :status, :boolean, default: true
    field :password_hash, :string
    field :is_admin, :boolean, default: false
    field :password, :string, virtual: true

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:username, :email, :phone, :status, :is_admin])
    |> validate_required([:username, :email, :phone])

  end

  def registration_changeset(user, attrs) do
    user
    |> cast(attrs, [:username, :email, :phone, :status, :password, :is_admin])
    |> validate_required([:username, :email, :phone, :status, :password])
    |>put_hash_on_password()

  end

  defp put_hash_on_password(changeset) do
    IO.inspect(changeset, label: "here is the data")
    case get_change(changeset, :password) do
      nil -> changeset
      password -> put_change(changeset, :password_hash, Bcrypt.hash_pwd_salt(password))
    end
  end

  defp hash_and_assign_id(password) do
    pasword_hash = Bcrypt.hash_pwd_salt(password)
  end

  def update_status(user, status) do
    user
    |> changeset(%{status: status})
    |> Repo.update!()
  end
end
