defmodule FirstProjectWeb.VideoController do
  use FirstProjectWeb, :controller
  import Ecto.Query, warn: false
  alias FirstProject.Videos
  # alias FirstProject.Videos.Video
  alias FirstProject.Category
  plug :load_categories when action in [:new, :create, :edit, :update]

  def index(conn, _params, user) do
    videos = Videos.list_videos(user_videos(user))
    render(conn, "index.html", videos: videos)
  end

  @spec new(Plug.Conn.t(), any, %{:__struct__ => atom, optional(any) => any}) :: Plug.Conn.t()
  def new(conn, _params, user) do
    changeset =
      user
      |> Ecto.build_assoc(:videos)
      |> Videos.change_video()
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"video" => video_params}, user) do
    video =
      user
      |> build_assoc(:videos)
    case Videos.create_video(video, video_params) do
      {:ok, _video} ->
        conn
        |> put_flash(:info, "Video created successfully.")
        |> redirect(to: Routes.video_path(conn, :index))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}, user) do
    video = Videos.get_video!(user_videos(user),id)
    render(conn, "show.html", video: video)
  end

  def edit(conn, %{"id" => id}, user) do
    video = Videos.get_video!(user_videos(user),id)
    changeset = Videos.change_video(video)
    render(conn, "edit.html", video: video, changeset: changeset)
  end

  def update(conn, %{"id" => id, "video" => video_params}, user) do
    video = Videos.get_video!(user_videos(user),id)

    case Videos.update_video(video, video_params) do
      {:ok, video} ->
        conn
        |> put_flash(:info, "Video updated successfully.")
        |> redirect(to: Routes.video_path(conn, :show, video))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", video: video, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}, user) do
    video = Videos.get_video!(user_videos(user),id)
    {:ok, _video} = Videos.delete_video(video)

    conn
    |> put_flash(:info, "Video deleted successfully.")
    |> redirect(to: Routes.video_path(conn, :index))
  end
  def action(conn, _) do
    apply(__MODULE__, action_name(conn),
    [conn, conn.params, conn.assigns.current_user])
  end

  defp user_videos(user) do
    assoc(user, :videos)
  end

  defp load_categories(conn, _) do
    query =
    Category
    |> Category.alphabetical
    |> Category.names_and_ids
    categories = Repo.all query
    assign(conn, :categories, categories)
  end
end
