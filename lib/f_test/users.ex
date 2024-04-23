defmodule FTest.Users do
  @moduledoc """
  The Users context.
  """

  import Ecto.Query, warn: false
  alias FTest.Repo

  alias FTest.Users.User

  @doc """
  Returns the list of users.

  ## Examples

      iex> list_users()
      [%User{}, ...]

  """
  def list_users do
    User
    |>where(status: true)
    |>Repo.all()
  end

  @doc """
  Gets a single user.

  Raises `Ecto.NoResultsError` if the User does not exist.

  ## Examples

      iex> get_user!(123)
      %User{}

      iex> get_user!(456)
      ** (Ecto.NoResultsError)

  """
  def get_user!(id), do: Repo.get!(User, id)

  @doc """
  Creates a user.

  ## Examples

      iex> create_user(%{field: value})
      {:ok, %User{}}

      iex> create_user(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_user(attrs \\ %{}) do
    email = attrs["email"]
    IO.inspect(email)
    user = get_user_by_email(email)
    IO.inspect(user, label: "----uza---")

    case user do
      nil->
        %User{}
        |> User.registration_changeset(attrs)
        |> Repo.insert()
      %User{} ->
        :user_exist
    end

  end

  def get_user_by_email(email) do
    User
    |>where(email: ^email)
    |>Repo.one()
  end

  @doc """
  Updates a user.

  ## Examples

      iex> update_user(user, %{field: new_value})
      {:ok, %User{}}

      iex> update_user(user, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_user(%User{} = user, attrs) do
    user
    |> User.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a user.

  ## Examples

      iex> delete_user(user)
      {:ok, %User{}}

      iex> delete_user(user)
      {:error, %Ecto.Changeset{}}

  """


  def delete_user(id) do
    user = Repo.get!(User, id)
    updated_user =User.update_status(user, false)
    {:ok, updated_user}

  end



  @doc """
  Returns an `%Ecto.Changeset{}` for tracking user changes.

  ## Examples

      iex> change_user(user)
      %Ecto.Changeset{data: %User{}}

  """
  def change_user(%User{} = user, attrs \\ %{}) do
    User.changeset(user, attrs)
  end

  def change_user_reg(%User{} = user, attrs \\ %{}) do
    User.registration_changeset(user, attrs)
  end


  def list_users(criteria) when is_list(criteria) do
    query = from(d in User)

    Enum.reduce(criteria, query, fn
      {:paginate, %{page: page, per_page: per_page}}, query ->
        from q in query,
          offset: ^((page - 1) * per_page),
          limit: ^per_page

      {:sort, %{sort_by: sort_by, sort_order: sort_order}}, query ->
        from q in query, order_by: [{^sort_order, ^sort_by}]
    end)
    |> Repo.all()
  end

end
