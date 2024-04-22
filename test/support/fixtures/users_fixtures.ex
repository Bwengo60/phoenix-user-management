defmodule FTest.UsersFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `FTest.Users` context.
  """

  @doc """
  Generate a user.
  """
  def user_fixture(attrs \\ %{}) do
    {:ok, user} =
      attrs
      |> Enum.into(%{
        username: "some username",
        email: "some email",
        phone: "some phone"
      })
      |> FTest.Users.create_user()

    user
  end
end
