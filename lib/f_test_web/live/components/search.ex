defmodule FTestWeb.Components.Search do
  use Phoenix.LiveComponent

  def render(assigns) do
    ~H"""
       <div>
          <%= if @searched_users != nil do %>
          <%= for user <- @searched_users do %>
              <h2> <%= user.username %> </h2>
          <% end %>
          <% else %>
              <h2> No Results found </h2>
          <% end %>
       </div>
    """
  end
end
