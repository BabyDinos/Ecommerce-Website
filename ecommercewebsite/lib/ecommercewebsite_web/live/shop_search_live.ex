defmodule EcommercewebsiteWeb.ShopSearchLive do
  use EcommercewebsiteWeb, :live_view

  def render(assigns) do
    ~H"""
      <!DOCTYPE html>
      <head>
      <link href="https://cdnjs.cloudflare.com/ajax/libs/flowbite/2.0.0/flowbite.min.css" rel="stylesheet" />
      </head>
      <body>
       Search
      <script src="../path/to/flowbite/dist/flowbite.min.js"></script>
      </body>
    """
    end

    def mount(_params, _session, socket) do
      {:ok, socket}
    end
end
