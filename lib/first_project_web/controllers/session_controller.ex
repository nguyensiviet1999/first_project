defmodule FirstProjectWeb.SessionController do
  use FirstProjectWeb, :controller
  alias FirstProjectWeb.Auth
  def new(conn, _) do
    render conn, "new.html"
  end

  def create(conn, %{"session" => %{"email" => user, "password" => pass}}) do
    case Auth.login_by_email_and_pass(conn, user, pass, repo: Repo) do
      {:ok, conn} ->
        conn
        |> put_flash(:info, "Welcome back!")
        |> redirect(to: Routes.page_path(conn,:index))
      {:error,_reason, conn } ->
      conn
      |> put_flash(:error, "Invalid username/password combination")
      |> render("new.html")
    end
  end
  @spec delete(atom | %{:__struct__ => atom, optional(any) => any}, any) :: Plug.Conn.t()
  def delete(conn, _) do
    conn
    |> Auth.logout()
    |> redirect(to: Routes.page_path(conn, :index))
  end
end
