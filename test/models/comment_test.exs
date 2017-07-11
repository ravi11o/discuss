defmodule Discusss.CommentTest do
  use Discusss.ModelCase

  alias Discusss.Comment

  @valid_attrs %{text: "some text"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Comment.changeset(%Comment{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Comment.changeset(%Comment{}, @invalid_attrs)
    refute changeset.valid?
  end
end
