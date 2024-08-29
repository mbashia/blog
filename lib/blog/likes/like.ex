defmodule Blog.Likes.Like do
  use Ecto.Schema
  import Ecto.Changeset
  alias Blog.Accounts.User
  alias Blog.Posts.Post

  schema "likes" do
    belongs_to :user, User, foreign_key: :user_id
    belongs_to :post, Post, foreign_key: :post_id

    timestamps()
  end

  @doc false
  def changeset(like, attrs) do
    like
    |> cast(attrs, [:post_id, :user_id])
    |> validate_required([:post_id, :user_id])
  end
end
