defmodule FTest.AdditionalFunctionality do
alias FTest.Users.User

  def get_users_by_name(name) do
    case Enum.filter(FTest.Users.list_users(), &(&1.username == name)) do
      [] ->
        nil
      user = users ->
        users
    end
  end

  def user_suggestion(""), do: FTest.Users.list_users()
  def user_suggestion(prefix) do
  users = FTest.Users.list_users() || []  # Use empty list as default if list_users() returns nil
  Enum.filter(users, &has_prefix?(&1.username, prefix))
  end

defp has_prefix?(username, prefix) do
  String.starts_with?(String.downcase(username), String.downcase(prefix))
end

end
