defmodule EcommercewebsiteWeb.ShopSearchLive do
  use EcommercewebsiteWeb, :live_view

  def render(assigns) do
    ~H"""
      <!DOCTYPE html>
      <head>
      </head>
      <body>
       Search
      </body>
    """
    end

    def mount(_params, _session, socket) do
      {:ok, socket}
    end
end
