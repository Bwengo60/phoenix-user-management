defmodule FTestWeb.ProfileComponent do
  alias FTest.ShowPosts
  use FTestWeb, :live_view
  import FTestWeb.LiveHelpers

  def mount(_param, session, socket) do
    if connected?(socket) do
      :timer.send_interval(1000, self(), :tick)

    end
    socket = assign_defaults(session, socket)
    socket = assign(socket, posts: ShowPosts.post_rate())
    {:ok, socket}
  end

  def handle_info(:tick, socket) do
    socket = assign(socket, posts: ShowPosts.post_rate())
    {:noreply, socket}
  end


end
