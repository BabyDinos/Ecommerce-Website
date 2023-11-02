defmodule EcommercewebsiteWeb.ShopLive do
  use EcommercewebsiteWeb, :live_view

  alias Ecommercewebsite.Items
  alias Ecommercewebsite.Shop
  alias Ecommercewebsite.Accounts
  alias Ecommercewebsite.Accounts.UserInfo

  @posts_on_each_page 9

  def render(assigns) do
    ~H"""
      <!DOCTYPE html>
      <head>
      <link href="https://cdnjs.cloudflare.com/ajax/libs/flowbite/2.0.0/flowbite.min.css" rel="stylesheet" />
      </head>
      <body>
        <div class = "relative w-full h-2/5 flex justify-center bg-black">
          <%= if @show_edit_button do %>
            <div class="absolute justify-center items-center top-0 right-0 bg-black w-16 h-8 m-3 p-1 text-white rounded-full">
              <span class="items-start align-top m-1 text-sm font-bold text-white dark:text-gray-300">Edit</span>
              <label class="relative inline-flex items-center cursor-pointer">
                <%= if @edit_mode do %>
                  <input type="checkbox" phx-click="toggle_edit_mode" value="" class="sr-only peer" checked>
                <% else %>
                  <input type="checkbox" phx-click="toggle_edit_mode" value="" class="sr-only peer">
                <% end %>
                <div class="w-11 h-6 bg-gray-200 rounded-full peer dark:bg-gray-700 peer-focus:ring-4 peer-focus:ring-green-300 dark:peer-focus:ring-green-800 peer-checked:after:translate-x-full peer-checked:after:border-white after:content-[''] after:absolute after:top-0.5 after:left-[2px] after:bg-white after:border-gray-300 after:border after:rounded-full after:h-5 after:w-5 after:transition-all dark:border-gray-600 peer-checked:bg-green-600">
                </div>
              </label>

            </div>
          <% end %>


          <div class = "w-4/5">
            <div class = "w-full justify-center flex break-all" >
              <h1 class = "w-full flex text-white font-semibold text-8xl justify-center items-center align-middle text-center mt-64">
                <%= @shop_title %>
              </h1>
            </div>
            <div class = "w-full flex justify-center mt-4">
              <%= if @edit_mode do %>
                  <.form for={@shoptitle_form} phx-change="validate_shop_title" phx-submit="submit_shop_title">
                    <.input field={@shoptitle_form[:shop_title]} value={@shop_title} placeholder={@shop_title} type="text" required />
                    <div class = "justify-center w-full flex">
                      <button class = "mt-5 p-4 text-green-700 hover:text-white border border-green-700 hover:bg-green-800 focus:ring-4 focus:outline-none focus:ring-green-300 font-medium rounded-lg text-sm text-center dark:border-green-500 dark:text-green-500 dark:hover:text-white dark:hover:bg-green-600 dark:focus:ring-green-800">
                      Change Shop Title</button>
                    </div>
                  </.form>
              <% end %>
            </div>

            <div class = "w-full justify-center flex break-all" >
              <h2 class = "w-full flex text-white font-semibold text-5xl justify-center items-center align-middle text-center mt-64">
                <%= @shop_description %>
              </h2>
            </div>

            <div class = "w-full flex justify-center mt-4">
              <%= if @edit_mode do %>
                  <.form for={@shopdescription_form} phx-change="validate_shop_description" phx-submit="submit_shop_description">
                    <.input field={@shopdescription_form[:shop_description]} value={@shop_description} placeholder={@shop_description} type="text" required />
                    <div class = "justify-center w-full flex">
                      <button class = "mt-5 p-4  text-green-700 hover:text-white border border-green-700 hover:bg-green-800 focus:ring-4 focus:outline-none focus:ring-green-300 font-medium rounded-lg text-sm text-center dark:border-green-500 dark:text-green-500 dark:hover:text-white dark:hover:bg-green-600 dark:focus:ring-green-800">
                      Change Shop Description
                      </button>
                    </div>
                  </.form>
              <% end %>
            </div>


          </div>
        </div>
        <div class = "w-full h-1/6 flex justify-center">
          <h1 class = "font-semibold text-8xl text-center mt-64">
          Shop Our Collections
          </h1>
        </div>
        <div class = "w-3/5 h-3/8 flex mb-16 items-start justify-center">
          <%= if @edit_mode do %>
            <.button phx-click={show_modal("upload-form")} class = "w-2/6 h-1/6 font-medium text-6xl">Upload New Item</.button>
              <.modal id = "upload-form">
                <.form for={@items_form} phx-change= "validate_new_item" phx-submit="upload_new_item"
                  class = "mt-[5%] ml-[5%] font-medium text-6xl w-3/5" enctype="multipart/form-data">
                  <.input field={@items_form[:item_name]} value = {@item_name} placeholder = {@item_name} type="text" label="Item Name" required />
                  <.input field={@items_form[:description]}  value = {@description} placeholder = {@description} type="textarea" label="Description" required />
                  <.input field={@items_form[:price]} value = {@price} placeholder = {@price} type="number" label="Price" required />
                  <.input field={@items_form[:quantity]} value = {@quantity} placeholder = {@quantity} type="number" label="Quantity" required />
                  <.live_file_input upload={@uploads.image} required class = "w-full text-xl mb-5"/>
                  <%= for entry <- @uploads.image.entries do %>
                    <.live_img_preview entry={entry} />
                  <% end %>
                  <div class = "justify-end w-full flex">
                    <button phx-click={hide_modal("upload-form")} class = "mt-5 text-2xl text-black bg-green-600 p-4 rounded-md">Submit</button>
                  </div>
                </.form>
              </.modal>
          <% end %>
        </div>
        <div class="grid grid-cols-2 md:grid-cols-3 gap-4 mr-8 ml-8">
          <%= for post <- Enum.slice(@posts, (@page_number) * @posts_on_each_page, (@posts_on_each_page)) do %>
            <div class="relative flex flex-col m-0">
              <div class = "w-full h-full relative flex items-center justify-center border-solid border">

                <%= if @edit_mode do %>
                  <button class ="inline-flex items-center h-10 px-5 text-indigo-100 transition-colors duration-150 bg-red-500 focus:outline-none hover:bg-red-600 absolute top-0 right-0 text-2xl rounded transform translate-x-50 -translate-y-0" phx-click="delete_post"
                    phx-value-id={post.id} phx-value-file_path={post.img_file_name} data-confirm="Are you sure you want to delete this post?">
                    <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" class="bi bi-trash" viewBox="0 0 16 16"> <path d="M5.5 5.5A.5.5 0 0 1 6 6v6a.5.5 0 0 1-1 0V6a.5.5 0 0 1 .5-.5zm2.5 0a.5.5 0 0 1 .5.5v6a.5.5 0 0 1-1 0V6a.5.5 0 0 1 .5-.5zm3 .5a.5.5 0 0 0-1 0v6a.5.5 0 0 0 1 0V6z"/> <path fill-rule="evenodd" d="M14.5 3a1 1 0 0 1-1 1H13v9a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2V4h-.5a1 1 0 0 1-1-1V2a1 1 0 0 1 1-1H6a1 1 0 0 1 1-1h2a1 1 0 0 1 1 1h3.5a1 1 0 0 1 1 1v1zM4.118 4 4 4.059V13a1 1 0 0 0 1 1h6a1 1 0 0 0 1-1V4.059L11.882 4H4.118zM2.5 3V2h11v1h-11z"/> </svg>
                    <span>Delete</span>
                  </button>
                <% end %>
                <div class="w-full h-full bg-white border border-gray-200 rounded-lg shadow dark:bg-gray-800 dark:border-gray-700">
                  <section class="w-full h-full text-gray-700 body-font overflow-hidden bg-white">
                    <div class="w-full h-full container px-5 pt-24 pb-12 mx-auto">
                      <div class="h-full lg:w-4/5 mx-auto flex flex-wrap">
                        <div class = "h-3/4 max-w-full">
                          <img src = {post.img_file_name} class = "h-auto max-w-full rounded-t-lg p-6"/>
                        </div>
                        <div class="lg:w-1/2 w-full lg:pl-10 lg:py-6 mt-6 lg:mt-0">
                          <h2 class="text-sm title-font text-gray-500 tracking-widest"><%= @shop_title %></h2>
                          <h1 class="text-gray-900 text-3xl title-font font-medium mb-1"><%= post.item_name %></h1>
                          <p class="leading-relaxed"><%= post.description %></p>
                          <div class="align-bottom flex flex-row mt-6">
                            <span class="title-font font-medium text-2xl text-gray-900">$<%= post.price %></span>
                            <button class="flex ml-auto text-white bg-indigo-500 border-0 py-2 px-6 focus:outline-none hover:bg-indigo-600 rounded">Add to Cart</button>
                          </div>
                        </div>
                      </div>
                    </div>
                  </section>
                </div>
              </div>
            </div>
          <% end %>
        </div>

        <div class="flex flex-col items-center mt-6">
          <!-- Help text -->
          <span class="text-sm text-gray-700 dark:text-gray-400">
              Showing <span class="font-semibold text-gray-900 dark:text-white"><%= (@page_number * @posts_on_each_page) + 1 %></span> to <span class="font-semibold text-gray-900 dark:text-white"><%= (@page_number * @posts_on_each_page) + @current_posts %></span> of <span class="font-semibold text-gray-900 dark:text-white"><%= @total_posts %></span> Entries
          </span>
          <div class="inline-flex mt-2 xs:mt-0">
            <!-- Buttons -->
            <button phx-click="decrease_page_number" phx-value-page_number= {@page_number} phx-value-posts_on_each_page={@posts_on_each_page} class="flex items-center justify-center px-4 h-10 text-base font-medium text-white bg-gray-800 rounded-l hover:bg-gray-900 dark:bg-gray-800 dark:border-gray-700 dark:text-gray-400 dark:hover:bg-gray-700 dark:hover:text-white">
                <svg class="w-3.5 h-3.5 mr-2" aria-hidden="true" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 14 10">
                  <path stroke="currentColor" stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13 5H1m0 0 4 4M1 5l4-4"/>
                </svg>
                Prev
            </button>
            <button phx-click="increase_page_number" phx-value-page_number={@page_number} phx-value-posts_on_each_page={@posts_on_each_page} class="flex items-center justify-center px-4 h-10 text-base font-medium text-white bg-gray-800 border-0 border-l border-gray-700 rounded-r hover:bg-gray-900 dark:bg-gray-800 dark:border-gray-700 dark:text-gray-400 dark:hover:bg-gray-700 dark:hover:text-white">
                Next
                <svg class="w-3.5 h-3.5 ml-2" aria-hidden="true" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 14 10">
                <path stroke="currentColor" stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M1 5h12m0 0L9 1m4 4L9 9"/>
              </svg>
            </button>
          </div>
        </div>
      <script src="../path/to/flowbite/dist/flowbite.min.js"></script>
      </body>
    """
    end

    def mount(%{"username" => username}, _session, socket) do
      case userinfo = Accounts.get_userinfo_by_username(username) do
        nil ->
          socket =
            socket
            |> put_flash(:error, "The shop #{username} does not exist")
            |> push_navigate(to: ~p"/")
          {:error, socket}
        _ ->
          shop_id = userinfo.id
          changeset = Items.changeset(%Items{})
          socket =
            reset_socket(socket, shop_id)
            |> assign(:show_edit_button, socket.assigns.current_user.id == userinfo.user_id)
            |> assign(:edit_mode, false)
            |> assign(userinfo: userinfo)
            |> assign(:shop_title, userinfo.shop_title)
            |> assign(:shop_description, userinfo.shop_description)
            |> assign(page_title: userinfo.shop_title)
            |> assign_form(changeset, "items", :items_form)
            |> allow_upload(:image, accept: ~w(.png .jpg), max_entries: 1, auto_upload: true)
          {:ok, socket}
        end
    end

    def reset_socket(socket, shop_id) do
      posts = Shop.get_items(shop_id)
      socket =
        socket
        |> assign(:page_number, 0)
        |> assign(:item_name, "")
        |> assign(:description, "")
        |> assign(:price, "")
        |> assign(:quantity, "")
        |> assign(:posts, posts)
        |> assign(:posts_on_each_page, @posts_on_each_page)
        |> assign(:current_posts, min(length(posts), @posts_on_each_page))
        |> assign(:total_posts, length(posts))
      socket
    end

    def handle_event("toggle_edit_mode", _params, socket) do
      socket =
        if socket.assigns.edit_mode do
          put_flash(socket, :info, "You are exiting edit mode")
        else
          shoptitle_changeset = UserInfo.shop_title_changeset(%UserInfo{}, %{shop_title: socket.assigns.userinfo.shop_title})
          shopdescription_changeset = UserInfo.shop_description_changeset(%UserInfo{}, %{shop_description: socket.assigns.userinfo.shop_description})
          socket
            |> assign_form(shoptitle_changeset, "shoptitle", :shoptitle_form)
            |> assign_form(shopdescription_changeset, "shopdescription", :shopdescription_form)
            |> put_flash(:info, "You are now in edit mode")
        end
      socket = assign(socket, :edit_mode, not socket.assigns.edit_mode)
      {:noreply, socket}
    end

    def handle_event("validate_shop_title", %{"shoptitle" => userinfo}, socket) do
      changeset = UserInfo.shop_title_changeset(%UserInfo{}, userinfo)
      socket =
        socket
        |> assign(:shop_title, userinfo["shop_title"])
        |> assign_form(changeset, "shoptitle", :shoptitle_form)
      {:noreply, socket}
    end

    def handle_event("submit_shop_title", %{"shoptitle" => userinfo}, socket) do
      case Accounts.update_user_info(socket.assigns.userinfo.id, userinfo) do
        {:ok, _} ->
          {:noreply, put_flash(socket, :info, "Shop title successfully updated to #{userinfo["shop_title"]}")}
        {:error, _} ->
          {:noreply, put_flash(socket, :error, "Shop title not successfully updated")}
      end
    end

    def handle_event("validate_shop_description", %{"shopdescription" => userinfo}, socket) do
      changeset = UserInfo.shop_description_changeset(%UserInfo{}, userinfo)
      socket =
        socket
        |> assign(:shop_description, userinfo["shop_description"])
        |> assign_form(changeset, "shopdescription", :shopdescription_form)
      {:noreply, socket}
    end

    def handle_event("submit_shop_description", %{"shopdescription" => userinfo}, socket) do
      case Accounts.update_user_info(socket.assigns.userinfo.id, userinfo) do
        {:ok, _} ->
          {:noreply, put_flash(socket, :info, "Shop title successfully updated to #{userinfo["shop_description"]}")}
        {:error, _} ->
          {:noreply, put_flash(socket, :error, "Shop title not successfully updated")}
      end
    end

    def handle_event("validate_new_item", %{"items" => items}, socket) do
      changeset = Items.changeset(%Items{} ,items)
      socket =
        socket
        |> assign(:item_name, items["item_name"])
        |> assign(:description, items["description"])
        |> assign(:price, items["price"])
        |> assign(:quantity, items["quantity"])
        |> assign_form(changeset, "items", :items_form)
      {:noreply, socket}
    end

    def handle_event("upload_new_item", %{"items" => items}, socket) do
      case socket.assigns.uploads.image.entries do
        [%Phoenix.LiveView.UploadEntry{done?: true, ref: ref, client_name: client_name} | _] ->
          file_type = Path.extname(client_name)

          uploaded_entries = consume_uploaded_entries(socket, :image, fn %{path: path}, _entry ->
              dest = Path.join("uploads", Path.basename(path)) <> file_type
              File.cp!(path, dest)
              {:postpone, "/uploads/#{Path.basename(dest)}"}
          end)

          case uploaded_entries do
            [first | _rest] ->
              items =
                items
                |> Map.put("img_file_name", first)
                |> Map.put("shop_id", socket.assigns.userinfo.id)
              res = Shop.upload_items(items)
              case res do
                {:ok, _items} ->
                  cancel_upload(socket, :image, ref)
                  socket =
                    reset_socket(socket, socket.assigns.userinfo.id)
                    |> assign_form(Items.changeset(%Items{}), "items", :items_form)
                  {:noreply, put_flash(socket, :info, "File #{client_name} has been uploaded!")}
                {:error, _}->
                  {:noreply, socket}
              end

            [] ->
              IO.puts("No files uploaded")
              {:noreply, socket}
            end
        _ ->
          # Files are still in progress, do not consume them yet
          {:noreply, put_flash(socket, :info, "file has not finished uploading")}
      end
    end

    def handle_event("decrease_page_number", %{"page_number" => page_number, "posts_on_each_page" => posts_on_each_page}, socket) do
      page_number = String.to_integer(page_number)
      posts_on_each_page = String.to_integer(posts_on_each_page)
      if page_number != 0 do
        page_number = page_number - 1
        current_posts = length(Enum.slice(socket.assigns.posts, (page_number) * posts_on_each_page, (posts_on_each_page)))
        socket =
          socket
          |> assign(:page_number, page_number)
          |> assign(:current_posts, current_posts)
        {:noreply, socket}
      else
        {:noreply, socket}
      end
    end

    def handle_event("increase_page_number", %{"page_number" => page_number, "posts_on_each_page" => posts_on_each_page}, socket) do
      page_number = String.to_integer(page_number)
      posts_on_each_page = String.to_integer(posts_on_each_page)
      if (page_number + 1) * posts_on_each_page + 1 > socket.assigns.total_posts do
        {:noreply, socket}
      else
        page_number = page_number + 1
        current_posts = length(Enum.slice(socket.assigns.posts, (page_number) * posts_on_each_page, (posts_on_each_page)))
        socket =
          socket
          |> assign(:page_number, page_number)
          |> assign(:current_posts, current_posts)
        {:noreply, socket}
      end
    end

    def handle_event("delete_post", %{"id" => id, "file_path" => file_path}, socket) do
      socket =
        case Shop.delete_item(id) do
          {:ok, message} ->
            res = delete_file(file_path)
            IO.inspect(res)
            put_flash(socket, :info, message)
          {:error, message} ->
            put_flash(socket, :error, message)
        end
      {:noreply, reset_socket(socket, socket.assigns.userinfo.id)}
    end

    defp assign_form(socket, %Ecto.Changeset{} = changeset, name, form_name) do
      upload_form =
        changeset
        |> Map.put(:action, :validate)
        |> to_form(as: name)

      if changeset.valid? do
        socket
          |> assign(form_name, upload_form)
          |> assign(check_errors: false)
      else
        assign(socket, form_name, upload_form)
      end
    end

    defp delete_file(file_path) do

      full_path = Path.join(File.cwd!, file_path)
      IO.inspect(full_path)
      case File.rm(full_path) do
        :ok ->
          {:ok, "File deleted successfully"}

        {:error, reason} ->
          {:error, "File deletion failed: #{reason}"}
      end
    end
end
