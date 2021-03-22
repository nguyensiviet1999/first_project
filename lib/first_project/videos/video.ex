defmodule FirstProject.Videos.Video do
  use Ecto.Schema
  import Ecto.Changeset

  schema "videos" do
    field :description, :string
    field :title, :string
    field :url, :string
    belongs_to :user, FirstProject.Accounts.User
    belongs_to :category, FirstProject.Category
    timestamps()
  end
  # @required_fields ~w(url title description)
  # @optional_fields ~w()
  @doc false
  def changeset(video, attrs) do
    video
    |> cast(attrs, [:url, :title, :description])
    |> validate_required([:url, :title, :description])
    |> assoc_constraint(:category)
  end
end
