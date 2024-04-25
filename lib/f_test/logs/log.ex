defmodule FTest.Logs.Log do
  use Ecto.Schema
  import Ecto.Changeset

  schema "user_logs" do
    field :activity, :string
    belongs_to :user, FTest.Users.User
    timestamps()
  end

  def changeset(user_logs, attrs) do
    user_logs
    |>cast(attrs, [:activity, :user])
    |>validate_required([:activity, :user])
  end

end
