defmodule Ecommercewebsite.Repo.Migrations.DropPosts do
  use Ecto.Migration

  def change do
    execute("DROP TABLE IF EXISTS cart CASCADE")
    execute("DROP TABLE IF EXISTS items CASCADE")
    execute("DROP TABLE IF EXISTS userinfo CASCADE")
    execute("DROP TABLE IF EXISTS users_tokens CASCADE")
    execute("DROP TABLE IF EXISTS users CASCADE")
  end
end
