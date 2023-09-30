defmodule Ecommercewebsite.Items do
  use Ecto.Schema
  import Ecto.Changeset

  schema "items" do
    field :item_name, :string
    field :description, :string
    field :price, :float
    field :quantity, :integer
    field :img_file_name, :string

    timestamps()
  end

  @doc false
  def changeset(changeset, attrs \\ %{}) do
    changeset
    |> cast(attrs, [:item_name, :description, :price, :quantity, :img_file_name])
    |> validate_required([:item_name, :description, :price, :quantity, :img_file_name])
    |> validate_item_name()
    |> validate_description()
    |> validate_price()
    |> validate_quantity()
  end

  def validate_item_name(changeset) do
    changeset
    |> validate_required([:item_name])
    |> validate_length(:item_name, min: 1, max: 100)
  end

  def validate_description(changeset) do
    changeset
    |> validate_required([:description])
    |> validate_length(:description, min: 0, max: 300)
  end

  def validate_price(changeset) do
    price = get_field(changeset, :price)

    if price >= 0 and price <= 999 do
      changeset
    else
      add_error(changeset, :age, "must be between 0 and 999")
    end

  end

  def validate_quantity(changeset) do
    quantity = get_field(changeset, :quantity)

    if quantity >= 0 and quantity <= 999999999 do
      changeset
    else
      add_error(changeset, :quantity, "must be between 0 and 999999999")
    end

  end

end
