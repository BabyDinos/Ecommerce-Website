defmodule Ecommercewebsite.Repo do
  use Ecto.Repo,
    otp_app: :ecommercewebsite,
    adapter: Ecto.Adapters.Postgres
end
