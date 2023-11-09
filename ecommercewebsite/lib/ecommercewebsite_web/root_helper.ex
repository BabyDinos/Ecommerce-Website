defmodule RootHelper do
  alias Ecommercewebsite.Accounts
  defmacro __using__(_opts) do
    quote do
      def handle_event("validate_shop_search", %{"shop_title" => shop_title}, socket) do
        Accounts.search_shops_shop_title(shop_title)
        IO.inspect("validated_shop_search")
        {:noreply, socket}
      end

    end
  end
end
