defmodule RefugeWeb.BearController do
  use RefugeWeb, :controller

  alias Refuge.Wildthings
  alias Refuge.Wildthings.Bear

  def index(conn, _params) do
    bears = Wildthings.list_bears()
    render(conn, "index.html", bears: bears)
  end

  def new(conn, _params) do
    changeset = Wildthings.change_bear(%Bear{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"bear" => bear_params}) do
    case Wildthings.create_bear(bear_params) do
      {:ok, bear} ->
        conn
        |> put_flash(:info, "Bear created successfully.")
        |> redirect(to: bear_path(conn, :show, bear))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    bear = Wildthings.get_bear!(id)
    render(conn, "show.html", bear: bear)
  end

  def edit(conn, %{"id" => id}) do
    bear = Wildthings.get_bear!(id)
    changeset = Wildthings.change_bear(bear)
    render(conn, "edit.html", bear: bear, changeset: changeset)
  end

  def update(conn, %{"id" => id, "bear" => bear_params}) do
    bear = Wildthings.get_bear!(id)

    case Wildthings.update_bear(bear, bear_params) do
      {:ok, bear} ->
        conn
        |> put_flash(:info, "Bear updated successfully.")
        |> redirect(to: bear_path(conn, :show, bear))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", bear: bear, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    bear = Wildthings.get_bear!(id)
    {:ok, _bear} = Wildthings.delete_bear(bear)

    conn
    |> put_flash(:info, "Bear deleted successfully.")
    |> redirect(to: bear_path(conn, :index))
  end
end
