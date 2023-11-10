defmodule Ecommercewebsite.Repo.Migrations.DropPosts do
  use Ecto.Migration

  def change do
    drop table("cart")
    drop table("items")
    drop table("userinfo")
    drop table("users")
    drop table("users_tokens")
  end
end
