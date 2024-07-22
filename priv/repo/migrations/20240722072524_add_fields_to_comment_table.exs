defmodule Blog.Repo.Migrations.AddFieldsToCommentTable do
  use Ecto.Migration

  def change do
    alter table(:comment) do
      add :user_id, :integer
      add :post_id, :integer
    end
  end
end
