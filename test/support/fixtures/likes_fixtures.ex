defmodule Blog.LikesFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Blog.Likes` context.
  """

  @doc """
  Generate a like.
  """
  def like_fixture(attrs \\ %{}) do
    {:ok, like} =
      attrs
      |> Enum.into(%{
        post_id: 42,
        user_id: 42
      })
      |> Blog.Likes.create_like()

    like
  end
end
