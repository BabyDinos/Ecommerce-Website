defmodule Ecommercewebsite.Repo.Migrations.CreateTables do
  use Ecto.Migration

  def change do
    execute "CREATE EXTENSION IF NOT EXISTS citext", ""

    create table(:users) do
      add :email, :citext, null: false
      add :hashed_password, :string, null: false
      add :confirmed_at, :naive_datetime
      timestamps()
    end

    create unique_index(:users, [:email])

    create table(:users_tokens) do
      add :user_id, references(:users, on_delete: :delete_all), null: false
      add :token, :binary, null: false
      add :context, :string, null: false
      add :sent_to, :string
      timestamps(updated_at: false)
    end

    create index(:users_tokens, [:user_id])
    create unique_index(:users_tokens, [:context, :token])
    end

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

    create table(:items) do
      add :shop_id, references(:userinfo, on_delete: :delete_all), null: false
      add :item_name, :string
      add :description, :string
      add :price, :float
      add :quantity, :integer
      add :img_file_name, :string
    end
    create index(:items, [:shop_id])
    end

    create table(:cart) do
      add :quantity, :integer
      add :user_id, references(:users, on_delete: :delete_all), null: false
      add :item_id, references(:items, on_delete: :delete_all), null: false
      timestamps()
    end
    create unique_index(:cart, [:user_id, :item_id])
    end

  end
end
