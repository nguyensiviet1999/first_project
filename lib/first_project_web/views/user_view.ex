defmodule FirstProjectWeb.UserView do
  use FirstProjectWeb, :view
  alias FirstProject.Accounts.User
  def first_name(%User{name: name}) do
    name
    |> String.split(" ")
    |> Enum.at(0)
  end
  def render("user.json", %{user: user}) do
    %{id: user.id, name: user.name}
  end
end
