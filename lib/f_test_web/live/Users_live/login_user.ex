defmodule FTestWeb.UsersLive.LoginUser do
  use FTestWeb, :live_view

  def render(assigns) do
    ~H"""
    <form phx-submit="login">
      <input type="text" name="email" placeholder="Email" />
      <input type="password" name="password" placeholder="Password" />
      <button type="submit">Log In</button>
    </form>
    """
  end

  def handle_event("login", user_params, socket) do
    IO.inspect(user_params, label: "========the ultimate")
    case FTest.UserAuth.authenticate(user_params["email"], user_params["password"]) do
      nil ->
        {:noreply, put_flash(socket, :error, "Invalid Email or password")}
      user ->
        socket = assign(socket, :current_user, user)
        conn = Phoenix.Controller.current_conn(socket)
        {:noreply, redirect(socket, to: "/")}
    end
  end
end
