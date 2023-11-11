defmodule EcommercewebsiteWeb.ContactLive do
  use EcommercewebsiteWeb, :live_view

  def render(assigns) do
    ~H"""
      <!DOCTYPE html>
      <head>
      </head>
      <body>
        <h1 class = "w-full h-full text-center text-xl bg-white text-black">
          Contact
        </h1>
      </body>
    """
    end

    def mount(_params, _session, socket) do
      {:ok, socket}
    end

  end
