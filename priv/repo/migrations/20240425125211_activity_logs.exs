defmodule FTest.Repo.Migrations.ActivityLogs do
  use Ecto.Migration

  def change do
    create table(:user_logs)do
      add :activity, :string
      add :user, references("users")
    end
  end
end
