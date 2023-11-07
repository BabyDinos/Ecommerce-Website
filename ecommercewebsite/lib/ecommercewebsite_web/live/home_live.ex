defmodule EcommercewebsiteWeb.HomeLive do
  use EcommercewebsiteWeb, :live_view

  def render(assigns) do
    ~H"""
      <!DOCTYPE html>
      <head>
      </head>
      <body>
        <h1 class = "w-full h-full text-center text-xl bg-white text-black">
          Home page
        </h1>
      </body>
    """
    end

    def mount(_params, _session, socket) do
      {:ok, socket}
    end

    def handle_event("validate_shop_search", _params, socket) do
      # Accounts.search_shops(shop_title)
      {:noreply, socket}
    end

  end
