defmodule BlogWeb.PostLive.Show do
  use BlogWeb, :live_view

  alias Blog.Posts
  alias Blog.Comments.Comment
  alias Blog.Comments

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
    comments = Comments.get_comment_for_a_post(id)
    IO.inspect(comments)

    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:post, Posts.get_post!(id))
     |> assign(:comments, comments)
     |> assign(:comment, %Comment{})}
  end

  defp page_title(:show), do: "Show Post"
  defp page_title(:edit), do: "Edit Post"
  defp page_title(:add_comment), do: "Add Comment"
end
