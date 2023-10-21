defmodule Ecommercewebsite.Items do
  use Ecto.Schema
  import Ecto.Changeset

  schema "items" do
    field :item_name, :string
    field :description, :string
    field :price, :float
    field :quantity, :integer
    field :img_file_name, :string
    belongs_to :userinfo, Ecommercewebsite.Accounts.UserInfo, foreign_key: :shop_id
  end

  @doc false
  def changeset(changeset, attrs \\ %{}) do
    changeset
    |> cast(attrs, [:item_name, :description, :price, :quantity, :img_file_name, :shop_id])
    |> validate_required([:item_name, :description, :price, :quantity, :img_file_name])
    |> validate_item_name()
    |> validate_description()
    |> validate_price()
    |> validate_quantity()
  end

  def validate_item_name(changeset) do
    changeset
    |> validate_required([:item_name])
    |> validate_length(:item_name, min: 1, max: 100, message: "Must have a name")
  end

  def validate_description(changeset) do
    changeset
    |> validate_required([:description])
    |> validate_length(:description, min: 1, max: 300, message: "Must have a description")
  end

  def validate_price(changeset) do
    changeset
    |> validate_number(:price, greater_than_or_equal_to: 0, less_than_or_equal_to: 900, message: "Price must be in between 0 and 900")
  end

  def validate_quantity(changeset) do
    changeset
    |> validate_number(:quantity, greater_than_or_equal_to: 1, less_than_or_equal_to: 9999, message: "Price must be in between 1 and 9999")
  end

end
