defmodule Discusss.Topic do
  use Discusss.Web, :model

  schema "topics" do
    field :title, :string
    belongs_to :user, Discusss.User
    has_many :comments, Discusss.Comment
  end

  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:title])
    |> validate_required([:title])
  end
end