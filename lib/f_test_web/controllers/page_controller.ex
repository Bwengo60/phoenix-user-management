defmodule FTestWeb.PageController do
  use FTestWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
