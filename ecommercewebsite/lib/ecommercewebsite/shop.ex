defmodule Ecommercewebsite.Shop do

  import Ecto.Query, warn: false
  alias Ecommercewebsite.Repo

  alias Ecommercewebsite.Items

  def upload_items(attrs) do
    %Items{}
      |> Items.changeset(attrs)
      |> Repo.insert()
  end

  def update_items(attrs, id) do
    Repo.get!(Items, id)
      |> Ecto.Changeset.cast(attrs, [:item_name, :description, :price, :quantity, :img_file_name, :shop_id])
      |> Repo.update()
  end

  def get_items(shop_id) do
    query =
      from i in Items,
      where: i.shop_id == ^shop_id
    Repo.all(query)
  end

  def delete_item(id) do
    case Repo.get(Items, id) do
      nil ->
        {:error, "Post not found"}
      entry ->
        case Repo.delete(entry) do
          {:ok, _} ->
            {:ok, "Post deleted successfully"}

          {:error, _} ->
            {:error, "Post failed to delete"}
          {_, _} ->
            {:ok, "Default"}
        end
    end
  end

end
