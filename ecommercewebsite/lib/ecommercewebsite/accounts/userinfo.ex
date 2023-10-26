defmodule Ecommercewebsite.Accounts.UserInfo do
  use Ecto.Schema
  import Ecto.Changeset

  schema "userinfo" do
    field :username, :string
    field :shop_title, :string
    field :shop_description, :string, default: " "
    belongs_to :user, Ecommercewebsite.Accounts.User, foreign_key: :user_id

  end

  def shop_title_changeset(userinfo, attrs \\ %{}, opts \\ []) do
    userinfo
    |> cast(attrs, [:shop_title])
    |> validate_required([:shop_title])
    |> validate_shop_title(opts)
  end

  def changeset(userinfo, attrs \\ %{}, opts \\ []) do
    userinfo
    |> cast(attrs, [:username, :shop_title, :shop_description, :user_id])
    |> validate_required([:username, :shop_title, :shop_description])
    |> validate_username(opts)
    |> validate_shop_title(opts)
    |> validate_shop_description(opts)
  end

  def validate_username(changeset, opts) do
    changeset
    |> validate_required([:username])
    |> validate_format(:username, ~r/^[a-zA-Z0-9_]+$/, message: "must only contain numbers, letters, and underscore")
    |> validate_length(:username, min: 1,max: 20)
    |> maybe_validate_unique_username(opts)
  end

  def validate_shop_title(changeset, opts) do
    changeset
    |> validate_required([:shop_title])
    |> validate_format(:shop_title, ~r/^[a-zA-Z0-9\s]+$/, message: "must only contain letters, numbers, and spaces")
    |> validate_length(:shop_title, min: 1, max: 30)
    |> maybe_validate_unique_shop_title(opts)
  end

  def validate_shop_description(changeset, _opts) do
    changeset
    |> validate_required([:shop_description])
    |> validate_format(:shop_description, ~r/^[a-zA-Z0-9]+$/, message: "must only contain letters and numbers")
    |> validate_length(:shop_description, min: 0, max: 300)
  end

  defp maybe_validate_unique_username(changeset, opts) do
    if Keyword.get(opts, :validate_username, true) do
      changeset
      |> unsafe_validate_unique(:username, Ecommercewebsite.Repo)
      |> unique_constraint(:username)
    else
      changeset
    end
  end

  defp maybe_validate_unique_shop_title(changeset, opts) do
    if Keyword.get(opts, :validate_shop_title, true) do
      changeset
      |> unsafe_validate_unique(:shop_title, Ecommercewebsite.Repo)
      |> unique_constraint(:shop_title)
    else
      changeset
    end
  end

end
