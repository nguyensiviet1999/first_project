defmodule FirstProject.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field :email, :string
    field :name, :string
    field :password, :string
    field :password_hash, :string
    field :password_confirmation, :string, virtual: true
    has_many :videos, FirstProject.Videos.Video
    has_many :annotations, FirstProject.Multimedia.Annotation
    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:name, :email])
    |> validate_required([:name, :email])
    |> validate_length(:email, min: 1, max: 20)
    |> unique_constraint(:email)
  end
  def registration_changeset(model, params) do
    model
    |> changeset(params)
    |> cast(params,[:password])
    |> validate_length(:password, min: 6, max: 100)
    |> validate_confirmation(:password)
    |> put_pass_hash()
  end

  def put_pass_hash(changeset) do
    case changeset do
      %Ecto.Changeset{valid?: true, changes: %{password: pass}} ->
        put_change(changeset, :password_hash, Bcrypt.hash_pwd_salt(pass))
      _ ->
        changeset
    end
  end
end
