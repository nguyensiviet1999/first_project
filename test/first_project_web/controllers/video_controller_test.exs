defmodule FirstProjectWeb.VideoControllerTest do
  use FirstProjectWeb.ConnCase
  import FirstProjectWeb.Router.Helpers
  alias FirstProject.Videos
  alias FirstProject.Repo

  @create_attrs %{description: "some description", title: "some title", url: "some url"}
  @update_attrs %{description: "some updated description", title: "some updated title", url: "some updated url"}
  @invalid_attrs %{description: nil, title: nil, url: nil}

  def fixture(:video) do
    {:ok, video} = Videos.create_video(@create_attrs)
    video
  end
  setup %{conn: conn} = config do
    if email = config[:login_as] do
      user = insert_user(email: email)
      conn = assign(conn, :current_user, user)
      {:ok, conn: conn, user: user}
    else
      :ok
    end
  end
  @tag login_as: "max"
  test "lists all user's videos on index", %{conn: conn, user: user} do
    user_video = insert_video(user, title: "funny cats")
    other_video = insert_video(insert_user(email: "other"), title: "another video")
    conn = get conn, video_path(conn, :index)
    assert html_response(conn, 200) =~ "Listing Videos"
    assert String.contains?(conn.resp_body, user_video.title)
    refute String.contains?(conn.resp_body, other_video.title)
  end

  test "requires user authentication on all actions", %{conn: conn} do
    Enum.each([
    get(conn, video_path(conn, :new)),
    get(conn, video_path(conn, :index)),
    get(conn, video_path(conn, :show, "123")),
    get(conn, video_path(conn, :edit, "123")),
    put(conn, video_path(conn, :update, "123", %{})),
    post(conn, video_path(conn, :create, %{})),
    delete(conn, video_path(conn, :delete, "123")),
    ], fn conn ->
    assert html_response(conn, 302)
    assert conn.halted
    end)
  end

  alias FirstProject.Videos.Video
  @valid_attrs %{url: "http://youtu.be", title: "vid", description: "a vid"}
  @invalid_attrs %{title: "invalid"}
  defp video_count(query), do: Repo.one(from v in query, select: count(v.id))
  @tag login_as: "max"

  test "creates user video and redirects", %{conn: conn, user: user} do
    conn = post conn, video_path(conn, :create), video: @valid_attrs
    assert redirected_to(conn) == video_path(conn, :index)
    assert Repo.get_by!(Video, @valid_attrs).user_id == user.id
  end
  @tag login_as: "max"
  test "does not create video and renders errors when invalid", %{conn: conn} do
    count_before = video_count(Video)
    conn = post conn, video_path(conn, :create), video: @invalid_attrs
    assert html_response(conn, 200) =~ "check the errors"
    assert video_count(Video) == count_before
  end
  @tag login_as: "max"
  test "authorizes actions against access by other users",
    %{user: owner, conn: conn} do

    video = insert_video(owner, @valid_attrs)
    non_owner = insert_user(email: "sneaky")
    conn = assign(conn, :current_user, non_owner)

    assert_error_sent :not_found, fn ->
      get(conn, video_path(conn, :show, video))
    end
    assert_error_sent :not_found, fn ->
      get(conn, video_path(conn, :edit, video))
    end
    assert_error_sent :not_found, fn ->
      put(conn, video_path(conn, :update, video, video: @valid_attrs))
    end
    assert_error_sent :not_found, fn ->
      delete(conn, video_path(conn, :delete, video))
    end
  end
  describe "index" do
    test "lists all videos", %{conn: conn} do
      conn = get(conn, Routes.video_path(conn, :index))
      assert html_response(conn, 200) =~ "Listing Videos"
    end
  end

  describe "new video" do
    test "renders form", %{conn: conn} do
      conn = get(conn, Routes.video_path(conn, :new))
      assert html_response(conn, 200) =~ "New Video"
    end
  end

  describe "create video" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, Routes.video_path(conn, :create), video: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.video_path(conn, :show, id)

      conn = get(conn, Routes.video_path(conn, :show, id))
      assert html_response(conn, 200) =~ "Show Video"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.video_path(conn, :create), video: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Video"
    end
  end

  describe "edit video" do
    setup [:create_video]

    test "renders form for editing chosen video", %{conn: conn, video: video} do
      conn = get(conn, Routes.video_path(conn, :edit, video))
      assert html_response(conn, 200) =~ "Edit Video"
    end
  end

  describe "update video" do
    setup [:create_video]

    test "redirects when data is valid", %{conn: conn, video: video} do
      conn = put(conn, Routes.video_path(conn, :update, video), video: @update_attrs)
      assert redirected_to(conn) == Routes.video_path(conn, :show, video)

      conn = get(conn, Routes.video_path(conn, :show, video))
      assert html_response(conn, 200) =~ "some updated description"
    end

    test "renders errors when data is invalid", %{conn: conn, video: video} do
      conn = put(conn, Routes.video_path(conn, :update, video), video: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Video"
    end
  end

  describe "delete video" do
    setup [:create_video]

    test "deletes chosen video", %{conn: conn, video: video} do
      conn = delete(conn, Routes.video_path(conn, :delete, video))
      assert redirected_to(conn) == Routes.video_path(conn, :index)
      assert_error_sent 404, fn ->
        get(conn, Routes.video_path(conn, :show, video))
      end
    end
  end

  defp create_video(_) do
    video = fixture(:video)
    %{video: video}
  end
end
