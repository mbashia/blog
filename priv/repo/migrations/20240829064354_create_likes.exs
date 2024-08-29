defmodule Blog.Repo.Migrations.CreateLikes do
  use Ecto.Migration

  def change do
    create table(:likes) do
      add :post_id, :integer
      add :user_id, :integer

      timestamps()
    end
  end
end
