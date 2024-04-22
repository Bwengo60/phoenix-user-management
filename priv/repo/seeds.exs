# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     FTest.Repo.insert!(%FTest.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

FTest.Repo.insert!(%FTest.Users.User{
  username: "admin",
  email: "realadmin@email.com",
  phone: "0951234567",
  password_hash: Bcrypt.hash_pwd_salt("1234"),
  is_admin: true
})
