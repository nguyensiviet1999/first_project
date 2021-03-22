defmodule FirstProject.TestHelpers do
  alias FirstProject.Repo
  alias FirstProject.Accounts.User
  def insert_user(attrs \\ %{}) do
    changes = Dict.merge(%{
      name: "Some user",
      email: "user#{Base.encode16(:crypto.rand_bytes(8))}",
      password: "supersecret",
    },attrs)
    %User{}
    |> User.registration_changeset(changes)
    |> Repo.insert!()
  end
  def insert_video(user, attrs \\ %{}) do
    user
    |> Ecto.build_assoc(:videos, attrs)
    |> Repo.insert!()
  end
end
