defmodule FirstProjectWeb.CategoryController do
  use FirstProjectWeb, :controller

  import Ecto.Query, warn: false
  alias FirstProject.Repo
  alias FirstProject.Category

  def index(conn, _param) do
    categories = Repo.all(Category)
    render(conn, "index.html", categories: categories)
  end
  def new(conn, _param) do
    changeset = change_category(%Category{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"category" => category_param}) do
    case %Category{} |> change_category(category_param) |> Repo.insert() do
      {:ok, category}->
        conn
        |> put_flash(:info, "Create category success!")
        |> redirect(to: Routes.category_path(conn, :show, category))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end

  end

  def show(conn, %{"id" => id}) do
    category = Repo.get!(Category, id)
    render(conn, "show.html", category: category)
  end

  def edit(conn, %{"id" => id}) do
    category = Repo.get!(Category, id)
    changeset = category |> change_category
    render(conn, "edit.html", category: category, changeset: changeset)
  end

  def update(conn, %{"id" => id, "category" => category_param}) do
    category = Repo.get!(Category, id)
    case category |> change_category(category_param) |> Repo.update() do
      {:ok, category} ->
        conn
        |> put_flash(:info, "update successed!")
        |> redirect(to: Routes.category_path(conn, :show, category))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", category: category, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    category = Repo.get!(Category, id)
    {:ok, _category} = Repo.delete(category)
    conn
    |> put_flash(:info, "Delete successed")
    |> redirect(to: Routes.category_path(conn, :index))
  end
  defp change_category(%Category{} = category, attrs \\ %{}) do
    Category.changeset(category, attrs)
  end
end
