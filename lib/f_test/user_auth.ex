defmodule FTest.UserAuth do
  alias FTest.Users
  import Plug.Conn
  import Phoenix.Controller

  def authenticate(email, password) do
    user = Users.get_user_by_email(email)
    cond do
       user && Bcrypt.verify_pass(password, user.password_hash) -> user
       true -> nil
    end
  end

  def redirect_if_user_is_authenticated(conn, _opts) do
    if conn.assigns[:current_user] do
      conn
      |> redirect(to: signed_in_path(conn))
      |> halt()
    else
      conn
    end
  end

 defp signed_in_path(_conn), do: "/"

 def require_authenticated_user(conn, _opts) do
  if conn.assigns[:current_user] do
    conn
  else
    conn
    |> put_flash(:error, "You must log in to access this page.")
    |> maybe_store_return_to()
    |> redirect(to: "/user/login")
    |> halt()
  end
end

defp maybe_store_return_to(%{method: "GET"} = conn) do
  %{request_path: request_path, query_string: query_string} = conn
  return_to = if query_string == "", do: request_path, else: request_path <> "?" <> query_string
  put_session(conn, :user_return_to, return_to)
end

defp maybe_store_return_to(conn), do: conn

def fetch_current_user(conn, _opts) do
  {user_id, conn} = ensure_user_id(conn)
  user = user_id && Users.get_user!(user_id)
  assign(conn, :current_user, user)
end

defp ensure_user_id(conn) do
  if user_id = get_session(conn, :user_id) do
    {user_id, conn}
  else
    conn = fetch_cookies(conn, signed: [@remember_me_cookie])
    if user_id = conn.cookies[@remember_me_cookie] do
      {user_id, put_session(conn, :user_id, user_id)}
    else
      {nil, conn}
    end
  end
end


end
