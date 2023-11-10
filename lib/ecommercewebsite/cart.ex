defmodule Ecommercewebsite.Cart do
  use Ecto.Schema
  import Ecto.Changeset

  schema "cart" do
    field :quantity, :integer
    belongs_to :items, Ecommercewebsite.Items, foreign_key: :item_id
    belongs_to :users, Ecommercewebsite.Accounts.User, foreign_key: :user_id
    timestamps()
  end

  def changeset(changeset, attrs \\ %{}) do
    changeset
      |> cast(attrs, [:quantity, :item_id, :user_id])
      |> validate_required([:quantity])
      |> unique_constraint(:item_id, name: :cart_user_id_item_id_index)
      |> validate_quantity()
  end

  def validate_quantity(changeset) do
    changeset
    |> validate_number(:quantity, greater_than_or_equal_to: 1, less_than_or_equal_to: 9999, message: "Price must be in between 1 and 9999")
  end

end
