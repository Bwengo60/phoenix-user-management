defmodule FTest.Repo.Migrations.AddUserType do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :is_admin, :boolean, default: false
    end
    execute("UPDATE users SET is_admin = false")

  end
end
