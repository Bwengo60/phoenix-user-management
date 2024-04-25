defmodule FTest.Repo.Migrations.AddTimeStamps do
  use Ecto.Migration

  def change do
    alter table(:user_logs) do
      timestamps()
    end
  end
end
