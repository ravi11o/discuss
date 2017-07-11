defmodule Discusss.CommentController do
  use Discusss.Web, :controller

  alias Discusss.Comment
  alias Discusss.Topic

  def index(conn, _params, topic) do
    comments = Repo.all(topic_comments(topic))
    render(conn, "index.html", comments: comments, topic: topic)
  end

  def new(conn, _params, topic) do
    changeset = Comment.changeset(%Comment{})
    render(conn, "new.html", changeset: changeset, topic: topic)
  end

  def create(conn, %{"comment" => comment_params}, topic) do
    changeset = 
      conn.assigns.user
      |> build_assoc(:comments, topic_id: topic.id) 
      |> Comment.changeset(comment_params)

    case Repo.insert(changeset) do
      {:ok, comment} ->
        conn
        |> put_flash(:info, "Comment created successfully.")
        |> redirect(to: topic_path(conn, :show, topic))
      {:error, changeset} ->
        conn
        |> put_flash("error", "Enter Valid comment")
        |> redirect(to: topic_path(conn, :show, topic))
    end
  end

  def delete(conn, %{"id" => id}, topic) do
    comment = Repo.get!(Comment, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(comment)

    conn
    |> put_flash(:info, "Comment deleted successfully.")
    |> redirect(to: topic_path(conn, :show, topic))
  end

  def action(%{params: %{"topic_id" => topic_id}} = conn, _) do
    topic = Repo.get(Topic, topic_id)
    apply(__MODULE__, action_name(conn),
    [conn, conn.params, topic])
  end

  defp topic_comments(topic) do
    assoc(topic, :comments)
  end
end
