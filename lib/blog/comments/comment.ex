defmodule Blog.Comments.Comment do
  use Ecto.Schema
  import Ecto.Changeset
  alias Blog.Accounts.User
  alias Blog.Posts.Post

  schema "comment" do
    field :text, :string
    belongs_to :user, User, foreign_key: :user_id
    belongs_to :post, Post, foreign_key: :post_id
    timestamps()
  end

  @doc false
  def changeset(comment, attrs) do
    comment
    |> cast(attrs, [:text, :user_id, :post_id])
    |> validate_required([:text, :user_id, :post_id])
  end
end
