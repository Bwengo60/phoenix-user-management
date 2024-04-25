defmodule FTestWeb.UsersLive.Form do
  alias FTest.Users.User
  use FTestWeb, :live_component

  alias FTest.Users


  def update(%{user: user} = _assigns, socket) do
    edit_changeset = Users.change_user(user)
    edit_user = edit_changeset.valid?

    if edit_user do

      changeset = edit_changeset
      IO.inspect(changeset.data, label: "=================PARAMS edit method")

      {:ok,
      socket
      |> assign(changeset: changeset)
      |> assign(:error_msg, "")
      |> assign(:edit_user, edit_user)

      }
    else
      changeset = Users.change_user_reg(user)
      IO.inspect(changeset, label: "=================PARAMS create method")

      {:ok,
     socket
        |> assign(changeset: changeset)
        |> assign(:error_msg, "")
        |> assign(:edit_user, edit_user)

      }
    end

  end

  # def handle_event("validate", %{"user" => user_params}, socket) do
  #   changeset =
  #     socket.assigns.user
  #     |> Users.change_user(user_params)
  #     |> Map.put(:action, :validate)

  #   {:noreply, assign(socket, :changeset, changeset)}
  # end

  def handle_event("save-user", params, socket) do
    IO.inspect(params, label: "this is the params")

    if socket.assigns.edit_user do
      socket
      |>save_user(params )
    else
      socket
      |>save_users( params )
    end

  end



  defp save_users(socket, params) do
    IO.inspect(params, label: "=================PARAMS new")
    case Users.create_user(params["user"]) do
      {:ok, user} ->
        # conn =Plug.Cowboy.Conn
        # Plug.Conn.put_session(conn, :user_id, user.id)
        IO.inspect("------session started--------")
        # socket = assign(socket, :current_user, user)
        # {:noreply, redirect(socket, to: Routes.users_index_path(socket, :index))}

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

  defp save_user(socket, params) do
    IO.inspect(params, label: "=================PARAMS edit")

    IO.inspect(socket.assigns.changeset.data.id, label: "Sockets data ----------")

    id = socket.assigns.changeset.data.id
    user = Users.get_user!(id)
    case Users.update_user(user, params) do
      {:ok, user} ->
        IO.inspect(user, label: "We're updating instead")
        {:noreply, redirect(socket, to: "/")}
      {:error, msg} ->
        {:noreply, socket}
    end
  end




end
