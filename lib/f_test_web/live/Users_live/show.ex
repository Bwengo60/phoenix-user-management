defmodule FTestWeb.UsersLive.Show do
  use Phoenix.LiveComponent

  def show(assigns) do
    IO.inspect(assigns)
    ~H"""
        <p> <%= @user.username %></p>
        <p><%= @user.email %></p>
        <p><%= @user.phone %></p>
    """
  end
end
