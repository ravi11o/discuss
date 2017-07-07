defmodule Discusss.TopicController do
  use Discusss.Web, :controller

  alias Discusss.Topic

  plug Discusss.Plugs.RequireAuth when action in [:new, :create, :update, :edit, :delete]
  plug :check_topic_owner when action in [:edit, :update, :delete]

  def index(conn, _params) do
    topics = Repo.all(Topic)

    render conn, "index.html", topics: topics
  end

  def new(conn, _params) do
    changeset = Topic.changeset(%Topic{}, %{})

    render conn, "new.html", changeset: changeset
  end

  def create(conn, %{"topic" => topic}) do
    changeset = 
      conn.assigns.user
      |> build_assoc(:topics)
      |> Topic.changeset(topic)

    case Repo.insert(changeset) do
      {:ok, _topic} ->
        conn
        |> put_flash(:info, "Topic Created")
        |> redirect(to: topic_path(conn, :index))
      {:error, changeset} -> 
        conn
        |> put_flash(:error, "Something went wrong")
        |> render("new.html", changeset: changeset)
    end
  end

  def edit(conn, %{"id" => id}) do
    topic = Repo.get(Topic, id)
    changeset = Topic.changeset(topic)

    render conn, "edit.html", changeset: changeset, topic: topic
  end

  def update(conn, %{"id" => id, "topic" => topic}) do
    old_topic = Repo.get(Topic, id)
    changeset = 
      old_topic
      |> Topic.changeset(topic)

    case Repo.update(changeset) do
      {:ok, _topic} -> 
        conn
        |> put_flash(:info, "Updated Successfully")
        |> redirect(to: topic_path(conn, :index))
      {:error, changeset} -> 
        conn
        |> put_flash(:error, "Something went wrong")
        |> render("edit.html", changeset: changeset, topic: old_topic)
    end
  end

  def delete(conn, %{"id" => id}) do
    Repo.get!(Topic, id) |> Repo.delete!

    conn 
    |> put_flash(:info, "Topic deleted Successfully")
    |> redirect(to: topic_path(conn, :index))
  end

  def check_topic_owner(%{params: %{"id" => id}} = conn, _params) do
    if Repo.get(Topic, id).user_id == conn.assigns.user.id do
      conn
    else
      conn
      |> put_flash(:error, "You can't handle that.")
      |> redirect(to: topic_path(conn, :index))
      |> halt()
    end
  end
end