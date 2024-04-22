defmodule FTestWeb.UsersLive.Form do
  use FTestWeb, :live_component

  alias FTest.Users


  def update(%{user: user} = assigns, socket) do
    edit_changeset = Users.change_user(user)
    edit_user = edit_changeset.valid?

    if edit_user do
      changeset = edit_changeset
      {:ok,
     socket
        |> assign(changeset: changeset)
        |> assign(:error_msg, "")
        |> assign(:edit_user, edit_user)

      }
    else
      changeset = Users.change_user_reg(user)

      {:ok,
     socket
        |> assign(changeset: changeset)
        |> assign(:error_msg, "")
        |> assign(:edit_user, edit_user)

      }
    end

  end



end
