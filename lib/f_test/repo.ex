defmodule FTest.Repo do
  use Ecto.Repo,
    otp_app: :f_test,
    adapter: Ecto.Adapters.Postgres
end
