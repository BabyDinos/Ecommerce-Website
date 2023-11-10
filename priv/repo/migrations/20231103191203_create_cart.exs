defmodule Ecommercewebsite.Repo.Migrations.CreateCart do
  use Ecto.Migration

  def change do
    create table(:cart) do
      add :quantity, :integer
      add :user_id, references(:users, on_delete: :delete_all), null: false
      add :item_id, references(:items, on_delete: :delete_all), null: false
      timestamps()
    end
    create index(:cart, [:user_id, :item_id])
    create unique_index(:cart, [:user_id, :item_id])
  end
end