defmodule Ecommercewebsite.Repo.Migrations.Items do
  use Ecto.Migration

  def change do
    create table(:items) do
      add :item_name, :string
      add :description, :string
      add :price, :float
      add :quantity, :integer
      add :img_file_name, :string
    end
  end
end
