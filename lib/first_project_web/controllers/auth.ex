defmodule FirstProjectWeb.Auth do
  import Plug.Conn
  alias FirstProject.Accounts.User
  import Bcrypt, only: [verify_pass: 2, no_user_verify: 0]


  def init(opts) do
    Keyword.fetch!(opts, :repo)
  end

  def call(conn, repo) do
    user_id = get_session(conn, :user_id)
    user = user_id && repo.get(User, user_id)
    assign(conn, :current_user, user)
  end
  def login(conn, user) do
    conn
    |> assign(:current_user, user)
    |> put_session(:user_id, user.id)
    |> configure_session(renew: true)
  end
  def login_by_email_and_pass(conn, email, given_pass, opts) do
    repo = Keyword.fetch!(opts, :repo)
    user = repo.get_by(User, email: email)

    cond do
      user && verify_pass(given_pass,user.password_hash) ->
        {:ok, login(conn, user)}
      user ->
        {:error, :unauthorized, conn}
      true ->
        no_user_verify()
        {:error, :not_found, conn}
    end
  end
  def logout(conn) do
    configure_session(conn, drop: true)
  end
  import Phoenix.Controller
  alias FirstProjectWeb.Router.Helpers, as: Routes
  def authenticate_user(conn, _opts) do
    if conn.assigns.current_user do
      conn
    else
      conn
      |> put_flash(:error, "You must be logged in to access that page")
      |> redirect(to: Routes.page_path(conn, :index))
      |> halt()
      end
    end
end
