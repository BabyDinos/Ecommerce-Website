defmodule Ecommercewebsite.Repo.Migrations.Items2 do
  use Ecto.Migration

  def change do
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
end
