defmodule EcommercewebsiteWeb.HomeLive do
  use EcommercewebsiteWeb, :live_view

  alias Ecommercewebsite.Items

  def render(assigns) do
    ~H"""
      <!DOCTYPE html>
      <head>
      </head>
      <body>
        <div class = "w-full h-2/5 flex justify-center bg-[url('/images/home-background.jpg')] bg-auto bg-center bg-no-repeat">
          <div class = "w-4/5 justify-center">
            <h1 class = "text-white font-semibold text-8xl text-center mt-64">
            My Store
            </h1>
            <h2 class = "p-20 font-medium text-6xl text-white">
            Welcome to my store!
            </h2>
          </div>
        </div>
        <div class = "w-full h-2/5 flex justify-center">
          <h1 class = "font-semibold text-8xl text-center mt-64">
          This is where my store will be
          </h1>
        </div>
        <div class = "w-full h-2/5 justify-center content-center">
          <button phx-click="start_upload_items" class = "w-full font-medium text-6xl">Upload New Item</button>
          <%= if @start_upload_items do %>
            <.form for={@upload_form} phx-submit="upload_new_item" class = "mt-[5%] ml-[20%] font-medium text-6xl w-3/5">
              <.input field={@upload_form[:item_name]} label="Item Name" required />
            </.form>
          <% end %>
        </div>
      </body>
    """
    end

    def mount(_params, _session, socket) do
      upload_form =
        %Items{}
        |> Items.changeset()
        |> to_form()
      socket =
        socket
        |> assign(page_title: "Home")
        |> assign(start_upload_items: false)
        |> assign(upload_form: upload_form)
      {:ok, socket}
    end

    def handle_event("start_upload_items", _params, socket) do
      socket =
        socket
        |> assign(start_upload_items: true)
      {:noreply, socket}
    end

    def handle_event("upload_new_item", _params, socket) do

      {:noreply, socket}
    end

end
