defmodule EcommercewebsiteWeb.CartLive do
  use EcommercewebsiteWeb, :live_view

  # alias Ecommercewebsite.Items
  alias Ecommercewebsite.Shop
  # alias Ecommercewebsite.Accounts
  # alias Ecommercewebsite.Accounts.UserInfo

  def render(assigns) do
    ~H"""
    <head>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/flowbite/2.0.0/flowbite.min.css" rel="stylesheet" />
    </head>
    <body>
      <div class = "relative w-full h-full flex justify-center bg-gray-50">





        <div class="justify-center overflow-y-auto w-1/2 h-[85%]">
            <%= for {cart, post} <- Enum.zip(@current_cart, @cart_posts) do %>
            <div class="relative flex flex-row w-full items-center mt-6 bg-white border border-gray-200 rounded-lg shadow md:flex-row w-1/2 hover:bg-gray-100 dark:border-gray-700 dark:bg-gray-800 dark:hover:bg-gray-700">
                <img class="object-cover w-full rounded-t-lg h-96 md:h-auto md:w-48 md:rounded-none md:rounded-l-lg" src={post.img_file_name}>
                <div class="flex flex-col justify-between p-4 leading-normal">
                    <h5 class="mb-2 text-2xl font-bold tracking-tight text-gray-900 dark:text-white break-all"><%= post.item_name %></h5>
                    <p class="mb-3 font-normal text-gray-700 dark:text-gray-400 break-all"><%= post.description %></p>
                    <div class="flex flex-row items-center gap-10">
                        <div class="flex w-32 h-1/2">
                            <div class="flex flex-row h-10 w-full rounded-lg relative bg-transparent">
                            <button phx-click="adjust_cart_quantity" phx-value-item_id={cart.item_id} phx-value-increment="-1" class=" bg-gray-300 text-gray-600 hover:text-gray-700 hover:bg-gray-400 h-full w-20 rounded-l cursor-pointer outline-none">
                                <span class="m-auto text-2xl font-thin">−</span>
                            </button>
                            <h1 class="outline-none focus:outline-none text-center w-full bg-gray-300 font-semibold text-md hover:text-black focus:text-black  md:text-basecursor-default flex items-center text-gray-700 justify-center" name="custom-input-number"><%= cart.quantity %></h1>
                            <button phx-click="adjust_cart_quantity" phx-value-item_id={cart.item_id} phx-value-increment="1" class="bg-gray-300 text-gray-600 hover:text-gray-700 hover:bg-gray-400 h-full w-20 rounded-r cursor-pointer">
                            <span class="m-auto text-2xl font-thin">+</span>
                            </button>
                            </div>
                        </div>
                        <p class="font-normal text-gray-700 dark:text-gray-400">$<%= cart.quantity * post.price %></p>
                    </div>

                </div>
            </div>
            <% end %>
          </div>
        <%= if @cart_length > 0 do %>
        <div class="flex w-[20%] absolute bottom-14 justify-center items-center text-center">
          <button phx-click="checkout" class="w-full inline-flex justify-center items-center px-4 py-2 text-sm font-medium text-center text-white bg-blue-700 rounded-lg hover:bg-blue-800 focus:ring-4 focus:ring-blue-300 dark:bg-blue-600 dark:hover:bg-blue-700 focus:outline-none dark:focus:ring-blue-800">Check Out<svg class="w-3.5 h-3.5 ml-2" aria-hidden="true" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 14 10">
          <path stroke="currentColor" stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M1 5h12m0 0L9 1m4 4L9 9"/>
          </svg></button>
        </div>
        <% end %>


      <%= if @show_alert  do %>
        <div class = "fixed top-0 right-0 z-40">
            <div id="alert-1" class="flex items-center p-4 mb-4 text-blue-800 rounded-lg bg-blue-50 dark:bg-gray-800 dark:text-blue-400" role="alert">
                <svg class="flex-shrink-0 w-4 h-4" aria-hidden="true" xmlns="http://www.w3.org/2000/svg" fill="currentColor" viewBox="0 0 20 20">
                <path d="M10 .5a9.5 9.5 0 1 0 9.5 9.5A9.51 9.51 0 0 0 10 .5ZM9.5 4a1.5 1.5 0 1 1 0 3 1.5 1.5 0 0 1 0-3ZM12 15H8a1 1 0 0 1 0-2h1v-3H8a1 1 0 0 1 0-2h2a1 1 0 0 1 1 1v4h1a1 1 0 0 1 0 2Z"/>
                </svg>
                <span class="sr-only">Info</span>
                <div class="ml-3 text-sm font-medium">
                <%= @alert_message %>
                </div>
                <button phx-click="dismiss_alert" type="button" class="ml-auto -mx-1.5 -my-1.5 bg-blue-50 text-blue-500 rounded-lg focus:ring-2 focus:ring-blue-400 p-1.5 hover:bg-blue-200 inline-flex items-center justify-center h-8 w-8 dark:bg-gray-800 dark:text-blue-400 dark:hover:bg-gray-700" data-dismiss-target="#alert-1" aria-label="Close">
                    <span class="sr-only">Close</span>
                    <svg class="w-3 h-3" aria-hidden="true" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 14 14">
                    <path stroke="currentColor" stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="m1 1 6 6m0 0 6 6M7 7l6-6M7 7l-6 6"/>
                    </svg>
                </button>
            </div>
        </div>
      <% end %>

      </div>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/flowbite/2.0.0/flowbite.min.js"></script>
    </body>
    """

  end


  def mount(_params, _session, socket) do
    cart = Shop.get_cart(socket.assigns.current_user.id)
    post = Shop.get_items_from_cart(cart)
    socket =
      socket
      |> assign(:show_alert, false)
      |> assign(:alert_message, "")
      |> assign(:current_cart, cart)
      |> assign(:cart_length, length(cart))
      |> assign(:cart_posts, post)
    {:ok, socket}
  end

  def handle_event("adjust_cart_quantity", %{"increment" => increment, "item_id" => item_id}, socket) do
    increment = String.to_integer(increment)
    item_id = String.to_integer(item_id)
    item_stock = Shop.get_item(item_id).quantity
    socket = case Enum.find(socket.assigns.current_cart, fn map -> map.item_id == item_id end) do
      nil ->
        IO.puts("No item in the cart with this id")
        socket
      map ->
        updated_item_in_cart = Map.update!(map, :quantity, &(&1 + increment))
        {message, updated_cart} = case updated_item_in_cart.quantity do
          q when q <= 0 ->
            {message, cart} = case Shop.delete_cart(updated_item_in_cart.id) do
              {:ok, _} ->
                message = "Removed from cart"
                updated_cart = Enum.reject(socket.assigns.current_cart, fn m -> m == map end)
                {message, updated_cart}
              {:error, _} ->
                message = "Could not remove from cart"
                {message, socket.assigns.current_cart}
              end
            {message, cart}
          q when q > item_stock ->
            message = "There is not enough stock"
            {message, socket.assigns.current_cart}
          _ ->
          attrs = %{
            "quantity" => updated_item_in_cart.quantity,
            "item_id" => updated_item_in_cart.item_id,
            "user_id" => updated_item_in_cart.user_id
          }
          case Shop.update_cart(attrs, updated_item_in_cart.id) do
            {:ok, _} ->
              updated_cart = Enum.map(socket.assigns.current_cart, fn m -> if m == map, do: updated_item_in_cart, else: m end)
              {"", updated_cart}
            {:error, _} ->
              message = "Could not update quantity"
              {message, socket.assigns.current_cart}
          end
        end

        post = Shop.get_items_from_cart(updated_cart)
        socket
          |> assign(:drawer_opened, true)
          |> assign(:current_cart, updated_cart)
          |> assign(:cart_posts, post)
          |> assign(:cart_length, length(updated_cart))
          |> show_alert(message)

    end

    {:noreply, socket}
  end

  def handle_event("checkout", _params, socket) do
    message = case Shop.checkout_cart(socket.assigns.current_user.id) do
      {_count, carts} ->
        Shop.update_stock(carts)
        "Thank you for your purchase!"
      _ ->
        "Could not confirm your purchase"
      end

    cart = Shop.get_cart(socket.assigns.current_user.id)
    post = Shop.get_items_from_cart(cart)
    socket =
      socket
      |> show_alert(message)
      |> assign(:current_cart, cart)
      |> assign(:cart_length, length(cart))
      |> assign(:cart_posts, post)
    {:noreply, socket}
  end

  def handle_event("dismiss_alert", _params, socket) do
    socket = assign(socket, :show_alert, false)
    {:noreply, socket}
  end

  defp show_alert(socket, message) do
    if message != "" do
      socket
      |> assign(:show_alert, true)
      |> assign(:alert_message, message)
    else
      socket
    end
  end

end
