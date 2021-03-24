defmodule FirstProject.Multimedia do
  @moduledoc """
  The Accounts context.
  """

  import Ecto.Query, warn: false
  alias FirstProject.Repo

  alias FirstProject.Multimedia.Annotation
  alias FirstProject.Videos.Video
  alias FirstProject.Accounts

  def annotate_video(%Accounts.User{id: user_id},video_id, attrs) do
    %Annotation{video_id: video_id, user_id: user_id}
    |> Annotation.changeset(attrs)
    |> Repo.insert()
  end

  def list_annotations(%Video{} = video, since_id \\ 0) do
    Repo.all(
      from a in Ecto.assoc(video, :annotations),
        where: a.id > ^since_id,
        order_by: [asc: a.at, asc: a.id],
        limit: 200,
        preload: [:user]
    )
  end
end
