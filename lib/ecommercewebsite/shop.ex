defmodule Ecommercewebsite.Shop do

  import Ecto.Query, warn: false
  alias Ecommercewebsite.Repo

  alias Ecommercewebsite.{Items, Cart}

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

  def get_item(post_id) do
    Repo.get!(Items, post_id)
  end

  def get_items(shop_id) do
    query =
      from i in Items,
      where: i.shop_id == ^shop_id
    Repo.all(query)
  end

  def get_items_from_cart(cart) do
    Enum.reduce(cart, [], fn c, acc ->
      p = get_item(c.item_id)
      [p | acc]
    end)
    |> Enum.reverse()
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

  def upload_cart(attrs) do
    %Cart{}
      |> Cart.changeset(attrs)
      |> Repo.insert()
  end

  def update_cart(attrs, cart_id) do
    Repo.get!(Cart, cart_id)
      |> Ecto.Changeset.cast(attrs, [:quantity, :item_id, :user_id])
      |> Repo.update()
  end

  def checkout_cart(user_id) do
    query =
      from i in Cart,
      where: i.user_id == ^user_id,
      select: i
    Repo.delete_all(query)
  end

  def update_stock(carts) do
    Enum.map(carts, fn cart_item ->
      post = get_item(cart_item.item_id)
      updated_item = Items.changeset(post, %{quantity: post.quantity - cart_item.quantity})
      Repo.update(updated_item)
    end)

  end

  def delete_cart(cart_id) do
    Repo.get!(Cart, cart_id)
      |> Repo.delete()
  end

  def get_cart(user_id) do
    query =
      from i in Cart,
      where: i.user_id == ^user_id
    Repo.all(query)
  end

end
