defmodule Discusss.Comment do
  use Discusss.Web, :model

  schema "comments" do
    field :text, :string
    belongs_to :user, Discusss.User, foreign_key: :user_id
    belongs_to :topic, Discusss.Topic, foreign_key: :topic_id

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:text])
    |> validate_required([:text])
  end
end
