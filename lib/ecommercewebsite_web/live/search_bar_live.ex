defmodule EcommercewebsiteWeb.SearchBarLive do
  use EcommercewebsiteWeb, :live_view

  alias Ecommercewebsite.Accounts

  def render(assigns) do
    ~H"""
      <div class="flex relative">
          <button type="button" data-collapse-toggle="navbar-search" aria-controls="navbar-search" aria-expanded="false" class="md:hidden text-gray-500 dark:text-gray-400 hover:bg-gray-100 dark:hover:bg-gray-700 focus:outline-none focus:ring-4 focus:ring-gray-200 dark:focus:ring-gray-700 rounded-lg text-sm p-2.5 mr-1" >
            <svg class="w-5 h-5" aria-hidden="true" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 20 20">
              <path stroke="currentColor" stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="m19 19-4-4m0-7A7 7 0 1 1 1 8a7 7 0 0 1 14 0Z"/>
            </svg>
            <span class="sr-only">Search</span>
          </button>
          <div class="relative hidden md:block">
            <div class="absolute inset-y-0 left-0 flex items-center pl-3 pointer-events-none">
              <svg class="w-4 h-4 text-gray-500 dark:text-gray-400" aria-hidden="true" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 20 20">
                <path stroke="currentColor" stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="m19 19-4-4m0-7A7 7 0 1 1 1 8a7 7 0 0 1 14 0Z"/>
              </svg>
              <span class="sr-only">Search icon</span>
            </div>
              <form role="search" phx-change="change">
                <input type="text" id="search-input" name="search[query]" class="block w-full p-2 pl-10 text-sm text-gray-900 border border-gray-300 rounded-lg bg-gray-50 focus:ring-blue-500 focus:border-blue-500 dark:bg-gray-700 dark:border-gray-600 dark:placeholder-gray-400 dark:text-white dark:focus:ring-blue-500 dark:focus:border-blue-500" placeholder="Search..." >
              </form>
          </div>
          <ul
            :if={@search_results != []}
            class="max-h-60 mt-10 absolute divide-y w-full divide-slate-200 overflow-y-auto rounded-b-lg border-t border-slate-200 text-sm leading-6"
            id="searchbox__results_list"
            role="listbox"
          >
            <%= for result <- @search_results do %>
              <li id={"#{result.id}"}>
                <.link
                  navigate={~p"/shop/#{result.username}"}
                  class="block p-4 bg-slate-100 hover:bg-slate-300 focus:outline-none focus:bg-slate-300 focus:text-sky-800"
                >
                  <%= result.username %>'s Shop
                  <br/>
                  <%= result.shop_title %>
                </.link>
              </li>
            <% end %>
          </ul>
          <button data-collapse-toggle="navbar-search" type="button" class="overflow-y-auto inline-flex items-center p-2 w-10 h-10 justify-center text-sm text-gray-500 rounded-lg md:hidden hover:bg-gray-100 focus:outline-none focus:ring-2 focus:ring-gray-200 dark:text-gray-400 dark:hover:bg-gray-700 dark:focus:ring-gray-600" aria-controls="navbar-search" aria-expanded="false" value="">
              <span class="sr-only">Open main menu</span>
              <svg class="w-5 h-5" aria-hidden="true" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 17 14">
                  <path stroke="currentColor" stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M1 1h15M1 7h15M1 13h15"/>
              </svg>
          </button>
        </div>

    """
    end

    def mount(_params, _session, socket) do
      {:ok, assign(socket, :search_results, [])}
    end

    def handle_event("change", %{"search" => %{"query" => search_query}}, socket) do
      if search_query == "" do
        socket =
          socket
          |> assign(:search_results, [])
        {:noreply, socket}
      else
        shop_title_results = Accounts.search_shops_shop_title(search_query)
        username_results = Accounts.search_shops_username(search_query)
        search_results = Enum.uniq(Enum.concat(shop_title_results, username_results))
        socket =
          socket
          |> assign(:search_results, search_results)
        {:noreply, socket}

      end
    end

end
