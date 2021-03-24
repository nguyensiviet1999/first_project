defmodule FirstProjectWeb.VideoChannel do
  use FirstProjectWeb, :channel
  alias FirstProject.{Accounts, Multimedia}
  def join("videos:" <> video_id, params, socket) do
    # :timer.send_interval(5_000, :ping)
    send(self(), :after_join)
    last_seen_id = params["last_seen_id"] || 0
    video_id = String.to_integer(video_id)
    video = FirstProject.Repo.get!(FirstProject.Videos.Video, video_id)
    annotations =
      video
      |> Multimedia.list_annotations(last_seen_id)
      |> Phoenix.View.render_many(FirstProjectWeb.AnnotationView, "annotation.json")
    {:ok, %{annotations: annotations}, assign(socket, :video_id, video_id)}
  end
  def handle_info(:after_join, socket) do
    push(socket, "presence_state", FirstProjectWeb.Presence.list(socket))
    {:ok, _} = FirstProjectWeb.Presence.track(
      socket,
      socket.assigns.user_id,
      %{device: "browser"}
    )
    {:noreply, socket}
  end

  def handle_in("new_annotation", params, user, socket) do
    changeset =
      user
      |> Ecto.build_assoc(:annotations, video_id: socket.assigns.video_id)
      |> Multimedia.Annotation.changeset(params)
    case FirstProject.Repo.insert(changeset) do
      {:ok, annotation}->
        broadcast! socket, "new_annotation", %{
          id: annotation.id,
          user: FirstProjectWeb.UserView.render("user.json", %{user: user}),
          body: annotation.body,
          at: annotation.at
        }
        {:reply, :ok, socket}
      {:error, changeset} ->
        {:reply, {:error,%{error: changeset}}, socket}
    end
  end
  def handle_in(event, params, socket) do
    user = FirstProject.Repo.get(Accounts.User, socket.assigns.user_id)
    handle_in(event, params, user, socket)
  end
end
