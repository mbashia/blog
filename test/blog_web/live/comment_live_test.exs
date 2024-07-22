defmodule BlogWeb.CommentLiveTest do
  use BlogWeb.ConnCase

  import Phoenix.LiveViewTest
  import Blog.CommentsFixtures

  @create_attrs %{text: "some text"}
  @update_attrs %{text: "some updated text"}
  @invalid_attrs %{text: nil}

  defp create_comment(_) do
    comment = comment_fixture()
    %{comment: comment}
  end

  describe "Index" do
    setup [:create_comment]

    test "lists all comment", %{conn: conn, comment: comment} do
      {:ok, _index_live, html} = live(conn, ~p"/comment")

      assert html =~ "Listing Comment"
      assert html =~ comment.text
    end

    test "saves new comment", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/comment")

      assert index_live |> element("a", "New Comment") |> render_click() =~
               "New Comment"

      assert_patch(index_live, ~p"/comment/new")

      assert index_live
             |> form("#comment-form", comment: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#comment-form", comment: @create_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/comment")

      html = render(index_live)
      assert html =~ "Comment created successfully"
      assert html =~ "some text"
    end

    test "updates comment in listing", %{conn: conn, comment: comment} do
      {:ok, index_live, _html} = live(conn, ~p"/comment")

      assert index_live |> element("#comment-#{comment.id} a", "Edit") |> render_click() =~
               "Edit Comment"

      assert_patch(index_live, ~p"/comment/#{comment}/edit")

      assert index_live
             |> form("#comment-form", comment: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#comment-form", comment: @update_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/comment")

      html = render(index_live)
      assert html =~ "Comment updated successfully"
      assert html =~ "some updated text"
    end

    test "deletes comment in listing", %{conn: conn, comment: comment} do
      {:ok, index_live, _html} = live(conn, ~p"/comment")

      assert index_live |> element("#comment-#{comment.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#comment-#{comment.id}")
    end
  end

  describe "Show" do
    setup [:create_comment]

    test "displays comment", %{conn: conn, comment: comment} do
      {:ok, _show_live, html} = live(conn, ~p"/comment/#{comment}")

      assert html =~ "Show Comment"
      assert html =~ comment.text
    end

    test "updates comment within modal", %{conn: conn, comment: comment} do
      {:ok, show_live, _html} = live(conn, ~p"/comment/#{comment}")

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Comment"

      assert_patch(show_live, ~p"/comment/#{comment}/show/edit")

      assert show_live
             |> form("#comment-form", comment: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert show_live
             |> form("#comment-form", comment: @update_attrs)
             |> render_submit()

      assert_patch(show_live, ~p"/comment/#{comment}")

      html = render(show_live)
      assert html =~ "Comment updated successfully"
      assert html =~ "some updated text"
    end
  end
end
