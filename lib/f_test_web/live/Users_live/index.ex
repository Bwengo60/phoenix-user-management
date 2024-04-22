defmodule FTestWeb.UsersLive.Index do
  alias FTestWeb.Components.Search
  alias FTest.AdditionalFunctionality
  alias FTest.Users
  alias FTest.Users.User
  use FTestWeb, :live_view
  import FTestWeb.LiveHelpers
  import FTestWeb.UsersLive.Show
  alias Plug

  def mount(_params, session, socket) do
    users = FTest.Users.list_users()
    socket = assign_defaults(session, socket)
    socket = assign(socket, users: users, show: false, search: false, searched_users: nil)
    {:ok, socket}
  end

  def handle_params(params, _uri, socket) do
    {:noreply,
    socket
    |>apply_action(socket.assigns.live_action, params)
    }
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:user, %User{})
    |> assign(:action, :new)

  end

  defp apply_action(socket, :index, _params) do
    socket

  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:user, Users.get_user!(id))
    |> assign(:action, :edit)
  end



  defp save_users(socket, :new, params) do
    case Users.create_user(params["user"]) do
      {:ok, user} ->
        # conn =Plug.Cowboy.Conn
        # Plug.Conn.put_session(conn, :user_id, user.id)
        IO.inspect("------session started--------")
        # socket = assign(socket, :current_user, user)
        {:noreply, redirect(socket, to: "/")}
      {:error, changeset} ->
        {:noreply, socket}
      :user_exist ->
        socket
        |>put_flash(:info, "The User already exists")
        |>assign(:error_msg, "User Already exists")
        {:noreply, socket}

    end
  end

  defp save_users(socket, :edit, params) do
    id = socket.assigns.user.id
    user = Users.get_user!(id)
    case Users.update_user(user, params["user"]) do
      {:ok, user} ->
        {:noreply, redirect(socket, to: "/")}
      {:error, msg} ->
        {:noreply, socket}
    end
  end

  def handle_event("update-status", %{"id" => id}, socket) do
    # user = Users.get_user!(id)
    case Users.delete_user(id) do
      {:ok, %User{} = updated_user} ->
        socket = assign(
          socket,
          users: Users.list_users()
        )
      {:noreply, socket}

      {:error, user} ->
        IO.inspect("--------------Frror")
        {:noreply,
        socket
      }
    end
  end

  def handle_event("save-user", params, socket) do
    socket
    |>save_users( socket.assigns.live_action, params)
  end

  def handle_event("show-user", %{"id" => id}, socket) do
    user = Users.get_user!(id)
    socket = assign(
      socket,
      user: user,
      show: true
    )
    {:noreply, socket}
  end

  def handle_event("search-user", params, socket) do
    search = params["ok"]["search"]
    socket = assign(
      socket, search: true,
     searched_users: AdditionalFunctionality.get_users_by_name(search)

    )
    {:noreply, socket}
  end

  def handle_event("suggest-search", params, socket) do
    search = params["ok"]["search"]
    socket = assign(
      socket,
      users: AdditionalFunctionality.user_suggestion(search)
    )
    {:noreply, socket}
  end
end
