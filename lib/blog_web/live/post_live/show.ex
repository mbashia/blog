defmodule BlogWeb.PostLive.Show do
  use BlogWeb, :live_view

  alias Blog.Posts
  alias Blog.Comments.Comment
  alias Blog.Comments
  alias Blog.Likes

  alias Blog.Accounts
  @impl true
  def mount(_params, session, socket) do
    user = Accounts.get_user_by_session_token(session["user_token"])

    {:ok,
     socket
     |> assign(:user, user)}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    post_likes = Likes.count_post_likes(id)

    like = Likes.get_like_by_post_and_user_id(socket.assigns.user.id, id)

    show_like =
      case like do
        nil -> false
        _ -> true
      end

    comments = Comments.get_comment_for_a_post(id)
    IO.inspect(comments)

    {:noreply,
     socket
     |> assign(:show_like, show_like)
     |> assign(:post_likes, post_likes)
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:post, Posts.get_post!(id))
     |> assign(:comments, comments)
     |> assign(:comment, %Comment{})}
  end

  @impl true
  def handle_event("like", %{"post_id" => post_id}, socket) do
    user = socket.assigns.user

    like = Likes.get_like_by_post_and_user_id(user.id, post_id)

    case like do
      nil ->
        {:ok, _} = Likes.create_like(%{user_id: user.id, post_id: post_id})
        post_likes = Likes.count_post_likes(post_id)

        {:noreply,
         socket
         |> assign(:show_like, true)
         |> assign(:post_likes, post_likes)}

      _ ->
        {:ok, _} = Likes.delete_like(like)
        post_likes = Likes.count_post_likes(post_id)

        {:noreply,
         socket
         |> assign(:show_like, false)
         |> assign(:post_likes, post_likes)}
    end
  end

  defp page_title(:show), do: "Show Post"
  defp page_title(:edit), do: "Edit Post"
  defp page_title(:add_comment), do: "Add Comment"
end
