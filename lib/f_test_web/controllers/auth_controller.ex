defmodule FTestWeb.AuthController do
  use FTestWeb, :controller
  import FTest.UserAuth

  def index(conn, _params) do
    conn
    |>render("index.html", current_user: nil)
  end

  def login(conn, params) do
    email = params["ok"]["email"]
    IO.inspect(authenticate(email, params["ok"]["password"]), label: "---------authentication here-----")
    case authenticate(email, params["ok"]["password"]) do

      nil ->
        conn
        |>put_flash(:error, "Invalid Credentials")
        |>render("index.html", current_user: nil)

      user ->
        if user.is_admin do
          conn
          |>put_session(:user_id, user.id)
          |> redirect(to: "/")

        else
          conn
          |>put_session(:user_id, user.id)
          |> redirect(to: "/profile")
        end

    end
  end


  def logout(conn, _params) do
    conn
    |> configure_session(drop: true)
    |> put_flash(:info, "Logged out successfully.")
    |> redirect(to: "/")
  end
end
