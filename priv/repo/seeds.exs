# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     FirstProject.Repo.insert!(%FirstProject.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.
user_data_fake = [%{id: "1", name: "José", email: "josevalim", password: "elixir"},
%{id: "2", name: "Bruce", email: "redrapids", password: "7langs"},
%{id: "3", name: "Chris", email: "chrismccord", password: "phx"}]
user_data_fake |> Enum.each(&(FirstProject.Accounts.create_user(&1)))
