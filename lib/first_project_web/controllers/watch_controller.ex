defmodule FirstProjectWeb.WatchController do
  use FirstProjectWeb, :controller
  alias FirstProject.Videos.Video
  alias FirstProject.Repo

  def show(conn, %{"id" => id}) do
    video = Repo.get!(Video, id)
    render(conn, "show.html", video: video)
  end
end
