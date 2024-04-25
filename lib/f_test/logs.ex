defmodule FTest.Logs do
  alias FTest.Repo
  alias Ecto.Multi

  alias FTest.Logs.Log

  def create_log(attrs \\ %{})do
    changeset = Log.changeset(%Log{}, attrs)
    Multi.new()
    |>Multi.insert(:log, changeset)
    |>Repo.transaction()
  end
end
