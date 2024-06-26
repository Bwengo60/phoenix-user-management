defmodule FTest.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :username, :string
      add :email, :string
      add :phone, :string

      timestamps()
    end
  end
end
