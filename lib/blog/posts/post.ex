defmodule Blog.Posts.Post do
  use Ecto.Schema
  import Ecto.Changeset

  alias Blog.Accounts.User
  alias Blog.Comments.Comment
  alias Blog.Likes.Like

  schema "posts" do
    field :body, :string
    field :title, :string
    belongs_to :user, User, foreign_key: :user_id
    has_many :comments, Comment
    has_many :likes, Like

    timestamps()
  end

  @doc false
  def changeset(post, attrs) do
    post
    |> cast(attrs, [:title, :body, :user_id])
    |> validate_required([:title, :body, :user_id])
  end
end
