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
    socket = assign(socket, users: users, show: false, search: false, searched_users: nil, options: %{page: 1, per_page: 5})
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

  defp apply_action(socket, :index, params) do
    page = String.to_integer(params["page"] || "1")
    per_page = String.to_integer(params["per_page"] || "5")

    paginate_options = %{page: page, per_page: per_page}
    users = Users.list_users(paginate: paginate_options)

      assign(socket,
        options: paginate_options,
        per_page: per_page,
        page: page,
        users: users
      )

  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:user, Users.get_user!(id))
    |> assign(:action, :edit)
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
