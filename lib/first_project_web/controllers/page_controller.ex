defmodule FirstProjectWeb.PageController do
  use FirstProjectWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end

  def world(conn, _params) do
    render(conn, "world.html")
  end
end
