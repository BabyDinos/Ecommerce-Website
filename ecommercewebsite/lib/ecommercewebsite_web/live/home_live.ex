defmodule EcommercewebsiteWeb.HomeLive do
  use EcommercewebsiteWeb, :live_view

  def render(assigns) do
    ~H"""
      <!DOCTYPE html>
      <head>
      </head>
      <body>
        <h1 class = "text-center text-xl text-black">
          Home page
        </h1>
      </body>
    """
    end

    def mount(_params, _session, socket) do
      {:ok, socket}
    end

  end
