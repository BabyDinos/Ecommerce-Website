defmodule Ecommercewebsite.Repo.Migrations.Userinfo3 do
  use Ecto.Migration

  def change do
    execute "CREATE EXTENSION IF NOT EXISTS citext", ""

    create table(:userinfo) do
      add :user_id, references(:users, on_delete: :delete_all), null: false
      add :username, :string, null: false
      add :shop_title, :string, null: false
      add :shop_description, :string
    end
    create index(:userinfo, [:user_id])
    create unique_index(:userinfo, [:username, :shop_title])
  end

end
